package mvp.buffer

import chisel3._
import chisel3.util._
import chisel3.experimental._

import mvp.common._
import mvp.polyram._

class poly_rd_interface(width: Int, nElems: Int, nBanks: Int, readDelay: Int) extends Module {
    override val desiredName = s"poly_rd_interface_${width}_${nElems}_${nBanks}_${readDelay}"

    val dataWidth = width
    val hiAddrWidth = utils.log2(nBanks)
    val loAddrWidth = utils.log2(nElems)
    val addrWidth = hiAddrWidth + loAddrWidth

    val io = IO(new Bundle {
        val vpu_rd = Flipped(new VpuRdPort(dataWidth, addrWidth, nBanks))
        val buf_rd = new BufRdPort(dataWidth, loAddrWidth, nBanks)
    })

    val lo_addr = utils.slice(io.vpu_rd.addr, 0, loAddrWidth)
    val hi_addr = utils.slice(io.vpu_rd.addr, loAddrWidth, addrWidth)

    io.buf_rd.addr := utils.repeat(nBanks, lo_addr)

    var lut = List.tabulate(nBanks) { x => (x.U -> io.buf_rd.data(x)) }

    io.vpu_rd.data := MuxLookup(ShiftRegister(hi_addr, readDelay), 0.U, lut)
}

class poly_wr_interface(width: Int, nElems: Int, nBanks: Int) extends Module {
    override val desiredName = s"poly_wr_interface_${width}_${nElems}_${nBanks}"

    val dataWidth = width
    val hiAddrWidth = utils.log2(nBanks)
    val loAddrWidth = utils.log2(nElems)
    val addrWidth = hiAddrWidth + loAddrWidth

    val io = IO(new Bundle {
        val vpu_wr = Flipped(new VpuWrPort(dataWidth, addrWidth, nBanks))
        val buf_wr = new BufWrPort(dataWidth, loAddrWidth, nBanks)
    })

    val lo_addr = utils.slice(io.vpu_wr.addr, 0, loAddrWidth)
    val hi_addr = utils.slice(io.vpu_wr.addr, loAddrWidth, addrWidth)

    io.buf_wr.addr := utils.repeat(nBanks, lo_addr)
    io.buf_wr.data := utils.repeat(nBanks, io.vpu_wr.data)

    when (io.vpu_wr.en) {
        io.buf_wr.en := UIntToOH(hi_addr).asBools
    } .otherwise {
        io.buf_wr.en := utils.repeat(nBanks, 0.B)
    }
}

class double_pp_buffer(width: Int, nElems: Int, nBanks: Int) extends Module {
  override val desiredName = s"double_pp_buffer_${width}_${nElems}_${nBanks}"

  val addrW = utils.log2(nElems)

  val io = IO(new Bundle {
    val i_done = Input(Bool())

    // unchanged endpoints
    val polyvec0_rd = Flipped(new BufRdPort(width, addrW, nBanks))
    val polyvec0_wr = Flipped(new BufWrPort(width, addrW, nBanks))
    val polyvec1_rd = Flipped(new BufRdPort(width, addrW, nBanks))
    val polyvec1_wr = Flipped(new BufWrPort(width, addrW, nBanks))

    // NEW: external banks (parent supplies two bank pairs)
    val banks_rd = Vec(2, new BufRdPort(width, addrW, nBanks))
    val banks_wr = Vec(2, new BufWrPort(width, addrW, nBanks))
  })

  val done_r = RegNext(io.i_done, 0.B)
  val s01 :: s10 :: Nil = Enum(2)
  val state = RegInit(s01)

  when (io.i_done && !done_r) {
    state := Mux(state === s01, s10, s01)
  }

  // Route polyvec endpoints ↔ external bank pairs
  switch(state) {
    is (s01) {
      io.polyvec0_rd <> io.banks_rd(0)
      io.polyvec0_wr <> io.banks_wr(0)
      io.polyvec1_rd <> io.banks_rd(1)
      io.polyvec1_wr <> io.banks_wr(1)
    }
    is (s10) {
      io.polyvec0_rd <> io.banks_rd(1)
      io.polyvec0_wr <> io.banks_wr(1)
      io.polyvec1_rd <> io.banks_rd(0)
      io.polyvec1_wr <> io.banks_wr(0)
    }
  }
}


class triple_pp_buffer(width: Int, nElems: Int, nBanks: Int) extends Module {
  override val desiredName = s"triple_pp_buffer_${width}_${nElems}_${nBanks}"

  val addrW = utils.log2(nElems)

  val io = IO(new Bundle {
    val i_done = Input(Bool())

    // unchanged endpoints (consumers/producers)
    val polyvec0_rd = Flipped(new BufRdPort(width, addrW, nBanks))
    val polyvec0_wr = Flipped(new BufWrPort(width, addrW, nBanks))
    val polyvec1_rd = Flipped(new BufRdPort(width, addrW, nBanks))
    val polyvec1_wr = Flipped(new BufWrPort(width, addrW, nBanks))
    val polyvec2_rd = Flipped(new BufRdPort(width, addrW, nBanks))
    val polyvec2_wr = Flipped(new BufWrPort(width, addrW, nBanks))

    // NEW: external banks (parent supplies three bank pairs)
    val banks_rd = Vec(3, new BufRdPort(width, addrW, nBanks))
    val banks_wr = Vec(3, new BufWrPort(width, addrW, nBanks))
  })

  val done_r = RegNext(io.i_done, 0.B)

  val s012 :: s201 :: s120 :: Nil = Enum(3)
  val state = RegInit(s012)

  when(io.i_done && !done_r) {
    state := MuxLookup(state, s012, Seq(
      s012 -> s201,
      s201 -> s120,
      s120 -> s012
    ))
  }

  // -------------------------
  // Default assignments
  // -------------------------
    io.banks_wr.foreach { wr =>
    wr.en   := VecInit(Seq.fill(nBanks)(false.B))
    wr.addr := VecInit(Seq.fill(nBanks)(0.U(addrW.W)))
    wr.data := VecInit(Seq.fill(nBanks)(0.U(width.W)))
    }
    io.banks_rd.foreach { rd =>
    rd.addr := VecInit(Seq.fill(nBanks)(0.U(addrW.W)))
    }

  io.polyvec0_rd.data := VecInit(Seq.fill(nBanks)(0.U))
  io.polyvec1_rd.data := VecInit(Seq.fill(nBanks)(0.U))
  io.polyvec2_rd.data := VecInit(Seq.fill(nBanks)(0.U))

  // -------------------------
  // Helper to connect pairs
  // -------------------------
  def connect(pIdx: Int, bIdx: Int): Unit = {
    val p_rd = Seq(io.polyvec0_rd, io.polyvec1_rd, io.polyvec2_rd)(pIdx)
    val p_wr = Seq(io.polyvec0_wr, io.polyvec1_wr, io.polyvec2_wr)(pIdx)
    p_rd <> io.banks_rd(bIdx)
    p_wr <> io.banks_wr(bIdx)
  }

  // -------------------------
  // FSM mapping
  // -------------------------
  switch(state) {
    is(s012) { connect(0,0); connect(1,1); connect(2,2) }
    is(s201) { connect(0,2); connect(1,0); connect(2,1) }
    is(s120) { connect(0,1); connect(1,2); connect(2,0) }
  }
}

