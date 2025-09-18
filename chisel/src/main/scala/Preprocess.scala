package mvp.preprocess

import mvp.common._
import mvp.intt._
import mvp.vpu4._
import mvp.polyram._
import mvp.buffer._

import chisel3._
import chisel3.util._

class preprocess_top_chisel extends Module {
  val bramDelay     = 1
  val INTT_COE_WIDTH = 35   // INTT coeffs are 35 bits

  val io = IO(new Bundle {
    val i_intt_start = Input(Bool())
    val o_intt_done  = Output(Bool())
    val i_pre_switch = Input(Bool())
    val i_mux_done   = Input(Bool())

    val i_coeff_index = Input(UInt(12.W))

    val dp1_wr = MixedVec(
      List.tabulate(1) { x => Flipped(new VpuWrPort(utils.MODWIDTH(x/2), 12, 8)) }
    )
    val dp1_rd = MixedVec(
      List.tabulate(1) { x => Flipped(new VpuRdPort(utils.MODWIDTH(x/2), 12, 8)) }
    )

    // Concatenated output of all 8 INTT lanes
    val o_intt_concat    = Output(UInt((utils.MODWIDTH(0) * 8).W))
    val o_intt_addr      = Output(UInt((9 * 8).W))
    val o_intt_we_result = Output(Bool())

    // Packed external TPP bank interfaces (leave unchanged)
    // ...

    // === NEW: Packed INTT buffer ports ===
    val inttWrEnPacked   = Output(UInt(8.W))
    val inttWrAddrPacked = Output(UInt((9 * 8).W))
    val inttWrDataPacked = Output(UInt((INTT_COE_WIDTH * 8).W))
    val inttRdAddrPacked = Output(UInt((9 * 8).W))
    val inttRdDataPacked = Input (UInt((INTT_COE_WIDTH * 8).W))
  })

  val u_intt = List.tabulate(1) { x => Module(new intt_wrapper(x/2)) }

  val u_tpp = List.tabulate(1) { x =>
    Module(new triple_pp_buffer(utils.MODWIDTH(x/2), 512, 8))
  }

  val u_dp1_wr_itf = List.tabulate(1) { x =>
    Module(new poly_wr_interface(utils.MODWIDTH(x/2), 512, 8))
  }
  val u_dp1_rd_itf = List.tabulate(1) { x =>
    Module(new poly_rd_interface(utils.MODWIDTH(x/2), 512, 8, bramDelay))
  }

  // ------------------------------
  // Pack INTT buf IOs (35-bit coeffs, 8 lanes)
  // ------------------------------
  {
    val wrEnBits   = Wire(Vec(8, Bool()))
    val wrAddrBits = Wire(Vec(8, UInt(9.W)))
    val wrDataBits = Wire(Vec(8, UInt(INTT_COE_WIDTH.W)))
    val rdAddrBits = Wire(Vec(8, UInt(9.W)))

    for (lane <- 0 until 8) {
      wrEnBits(lane)   := u_intt(0).io.wr_r.en(lane)
      wrAddrBits(lane) := u_intt(0).io.wr_r.addr(lane)
      wrDataBits(lane) := u_intt(0).io.wr_r.data(lane)

      rdAddrBits(lane) := u_intt(0).io.rd_r.addr(lane)

      val lo = lane * INTT_COE_WIDTH
      val hi = lo + INTT_COE_WIDTH - 1
      u_intt(0).io.rd_r.data(lane) := io.inttRdDataPacked(hi, lo)
    }

    io.inttWrEnPacked   := Cat(wrEnBits.reverse.map(_.asUInt))
    io.inttWrAddrPacked := Cat(wrAddrBits.reverse)
    io.inttWrDataPacked := Cat(wrDataBits.reverse)
    io.inttRdAddrPacked := Cat(rdAddrBits.reverse)
  }

  // ------------------------------
  // Packed external bank IOs (unchanged TPP code)
  // ------------------------------
  val N_PV   = u_tpp(0).io.banks_wr.length
  val N_BANK = u_tpp(0).io.banks_wr(0).addr.length
  val AW     = u_tpp(0).io.banks_wr(0).addr.head.getWidth
  val DW     = u_tpp(0).io.banks_wr(0).data.head.getWidth

  val tppWrEnPacked   = IO(Output(UInt((N_PV * N_BANK).W)))
  val tppWrAddrPacked = IO(Output(UInt((N_PV * N_BANK * AW).W)))
  val tppWrDataPacked = IO(Output(UInt((N_PV * N_BANK * DW).W)))
  val tppRdAddrPacked = IO(Output(UInt((N_PV * N_BANK * AW).W)))
  val tppRdDataPacked = IO(Input (UInt((N_PV * N_BANK * DW).W)))

  def lin(p: Int, b: Int) = p * N_BANK + b

  {
    val wrEnBits   = Wire(Vec(N_PV * N_BANK, Bool()))
    val wrAddrBits = Wire(Vec(N_PV * N_BANK, UInt(AW.W)))
    val wrDataBits = Wire(Vec(N_PV * N_BANK, UInt(DW.W)))
    val rdAddrBits = Wire(Vec(N_PV * N_BANK, UInt(AW.W)))

    for (p <- 0 until N_PV) {
      for (b <- 0 until N_BANK) {
        val k = lin(p, b)

        wrEnBits  (k) := u_tpp(0).io.banks_wr(p).en  (b)
        wrAddrBits(k) := u_tpp(0).io.banks_wr(p).addr(b)
        wrDataBits(k) := u_tpp(0).io.banks_wr(p).data(b)

        rdAddrBits(k) := u_tpp(0).io.banks_rd(p).addr(b)

        val rdLo = k * DW
        val rdHi = rdLo + DW - 1
        u_tpp(0).io.banks_rd(p).data(b) := tppRdDataPacked(rdHi, rdLo)
      }
    }

    tppWrEnPacked   := Cat((wrEnBits  .reverse).map(_.asUInt))
    tppWrAddrPacked := Cat((wrAddrBits.reverse))
    tppWrDataPacked := Cat((wrDataBits.reverse))
    tppRdAddrPacked := Cat((rdAddrBits.reverse))
  }

  // ------------------------------
  // Rest of plumbing
  // ------------------------------
  for (i <- 0 until 1) {
    io.dp1_wr(i)            <> u_dp1_wr_itf(i).io.vpu_wr
    io.dp1_rd(i)            <> u_dp1_rd_itf(i).io.vpu_rd

    u_tpp(i).io.polyvec0_wr <> u_dp1_wr_itf(i).io.buf_wr
    u_tpp(i).io.polyvec0_rd <> u_dp1_rd_itf(i).io.buf_rd
    u_tpp(i).io.polyvec1_wr <> u_intt(i).io.wr_l
    u_tpp(i).io.polyvec1_rd <> u_intt(i).io.rd_l
    u_tpp(i).io.polyvec2_rd <> DontCare
    u_tpp(i).io.polyvec2_wr <> DontCare
  }

  for (i <- 0 until 1) {
    u_tpp(i).io.i_done := io.i_pre_switch
  }

  {
    val lanes: Vec[UInt] = u_intt(0).io.wr_l.data
    io.o_intt_concat := Cat(lanes.reverse)
  }
  {
    val lanes: Vec[UInt] = u_intt(0).io.wr_l.addr
    io.o_intt_addr := Cat(lanes.reverse)
  }

  io.i_intt_start <> u_intt(0).io.ntt_start
  io.o_intt_done  := u_intt(0).io.ntt_done
  io.o_intt_we_result := u_intt(0).io.o_we_result
}
