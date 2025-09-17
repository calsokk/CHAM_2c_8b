package mvp.preprocess

import mvp.common._
import mvp.intt._
import mvp.vpu4._
import mvp.polyram._
import mvp.buffer._

import chisel3._
import chisel3.util._

class preprocess_top_chisel extends Module {
  val bramDelay = 1

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

    // NEW: concatenated output of all 8 INTT lanes
    val o_intt_concat    = Output(UInt((utils.MODWIDTH(0) * 8).W))
    val o_intt_addr      = Output(UInt((9 * 8).W))
    val o_intt_we_result = Output(Bool())

    // === NEW: Packed external TPP bank interfaces (parent will implement RAMs) ===
    // We define the exact widths after u_tpp is created (below), then rebind IO.
  })

  val u_intt = List.tabulate(1) { x => Module(new intt_wrapper(x/2)) }

  // INTT right-side scratch (kept here)
  val u_intt_buf = List.tabulate(1) { x =>
    Module(new poly_ram_wrapper(utils.MODWIDTH(x/2), 9, 8))
  }

  // Triple PP buffer (expects bank ports; we’ll route those up)
  val u_tpp = List.tabulate(1) { x =>
    Module(new triple_pp_buffer(utils.MODWIDTH(x/2), 512, 8))
  }

  // Interfaces to/from VPU adapter
  val u_dp1_wr_itf = List.tabulate(1) { x =>
    Module(new poly_wr_interface(utils.MODWIDTH(x/2), 512, 8))
  }
  val u_dp1_rd_itf = List.tabulate(1) { x =>
    Module(new poly_rd_interface(utils.MODWIDTH(x/2), 512, 8, bramDelay))
  }

  // ------------------------------
  // NEW: Packed external bank IOs
  // ------------------------------
  // Derive structural sizes from the TPP bank bundles to keep things consistent.
  // banks_wr: Vec[N_PV] of BufWrPort { en: Vec[N_BANK] Bool, addr: Vec[N_BANK] UInt(AW), data: Vec[N_BANK] UInt(DW) }
  // banks_rd: Vec[N_PV] of BufRdPort { addr: Vec[N_BANK] UInt(AW), data: Vec[N_BANK] UInt(DW) }
  val N_PV   = u_tpp(0).io.banks_wr.length
  val N_BANK = u_tpp(0).io.banks_wr(0).addr.length
  val AW     = u_tpp(0).io.banks_wr(0).addr.head.getWidth
  val DW     = u_tpp(0).io.banks_wr(0).data.head.getWidth

  // Create *packed* IO lines: EN, WR.ADDR, WR.DATA, RD.ADDR (all outputs) and RD.DATA (input)
  val tppWrEnPacked   = IO(Output(UInt((N_PV * N_BANK).W)))
  val tppWrAddrPacked = IO(Output(UInt((N_PV * N_BANK * AW).W)))
  val tppWrDataPacked = IO(Output(UInt((N_PV * N_BANK * DW).W)))
  val tppRdAddrPacked = IO(Output(UInt((N_PV * N_BANK * AW).W)))
  val tppRdDataPacked = IO(Input (UInt((N_PV * N_BANK * DW).W)))

  // Helper to compute flat bit indices
  def lin(p: Int, b: Int) = p * N_BANK + b

  // Pack WR.EN / WR.ADDR / WR.DATA and RD.ADDR from u_tpp into the IO buses
  // Also unpack RD.DATA back into u_tpp
  {
    // Mutable wires to gather concatenation elements
    val wrEnBits   = Wire(Vec(N_PV * N_BANK, Bool()))
    val wrAddrBits = Wire(Vec(N_PV * N_BANK, UInt(AW.W)))
    val wrDataBits = Wire(Vec(N_PV * N_BANK, UInt(DW.W)))
    val rdAddrBits = Wire(Vec(N_PV * N_BANK, UInt(AW.W)))

    // Drive per-bank connections and collect for packing
    for (p <- 0 until N_PV) {
      for (b <- 0 until N_BANK) {
        val k = lin(p, b)

        // Collect WR side from TPP
        wrEnBits  (k) := u_tpp(0).io.banks_wr(p).en  (b)
        wrAddrBits(k) := u_tpp(0).io.banks_wr(p).addr(b)
        wrDataBits(k) := u_tpp(0).io.banks_wr(p).data(b)

        // Collect RD.ADDR from TPP, and *return* RD.DATA back to TPP
        rdAddrBits(k) := u_tpp(0).io.banks_rd(p).addr(b)

        // Unpack RD.DATA from the packed input bus back to TPP
        val rdLo = k * DW
        val rdHi = rdLo + DW - 1
        u_tpp(0).io.banks_rd(p).data(b) := tppRdDataPacked(rdHi, rdLo)
      }
    }

    // Pack (Cat) in consistent MSB..LSB order: higher k toward MSB
    tppWrEnPacked   := Cat((wrEnBits  .reverse).map(_.asUInt))
    tppWrAddrPacked := Cat((wrAddrBits.reverse))
    tppWrDataPacked := Cat((wrDataBits.reverse))
    tppRdAddrPacked := Cat((rdAddrBits.reverse))
  }

  // ------------------------------
  // Rest of the original plumbing
  // ------------------------------
  for (i <- 0 until 1) {
    // VPU <-> adapters
    io.dp1_wr(i)            <> u_dp1_wr_itf(i).io.vpu_wr
    io.dp1_rd(i)            <> u_dp1_rd_itf(i).io.vpu_rd

    // TPP polyvec endpoints
    u_tpp(i).io.polyvec0_wr <> u_dp1_wr_itf(i).io.buf_wr
    u_tpp(i).io.polyvec0_rd <> u_dp1_rd_itf(i).io.buf_rd
    u_tpp(i).io.polyvec1_wr <> u_intt(i).io.wr_l
    u_tpp(i).io.polyvec1_rd <> u_intt(i).io.rd_l
    u_tpp(i).io.polyvec2_rd <> DontCare
    u_tpp(i).io.polyvec2_wr <> DontCare

    // INTT right side stays local
    u_intt(i).io.wr_r       <> u_intt_buf(i).io.wr
    u_intt(i).io.rd_r       <> u_intt_buf(i).io.rd
  }

  for (i <- 0 until 1) {
    u_tpp(i).io.i_done := io.i_pre_switch
  }

  // Concatenate the INTT's 8-lane output bus
  {
    val lanes: Vec[UInt] = u_intt(0).io.wr_l.data
    io.o_intt_concat := Cat(lanes.reverse)
  }
  {
    val lanes: Vec[UInt] = u_intt(0).io.wr_l.addr
    io.o_intt_addr := Cat(lanes.reverse)
  }

  // Control handshakes
  io.i_intt_start <> u_intt(0).io.ntt_start
  io.o_intt_done  := u_intt(0).io.ntt_done
  io.o_intt_we_result := u_intt(0).io.o_we_result
}
