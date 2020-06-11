import Chisel._
import ConveyInterfaces._
import TidbitsOCM._
import TidbitsDMA._
import TidbitsRegFile._
import TidbitsStreams._

class BRAMTestPipeIF(p: OCMParameters) extends Bundle {
  val startFill = Bool(INPUT)
  val startDump = Bool(INPUT)
  val done = Bool(OUTPUT)
  val baseAddr = UInt(INPUT, width = 64)
  val dumpSum = UInt(OUTPUT, width = p.readWidth)
  val mem = new MemMasterIF()
}

class BRAMTestPipe(p: OCMParameters) extends Module {
  val io = new BRAMTestPipeIF(p)

  val ocmc = Module(new OCMAndController(p, "ResultBRAM", true))
  // TODO make OCM user ports part of the test -- plugged to zero for now
  ocmc.io.ocmUser.req.addr := UInt(0)
  ocmc.io.ocmUser.req.writeData := UInt(0)
  ocmc.io.ocmUser.req.writeEn := Bool(false)

  ocmc.io.mcif.mode := Mux(io.startDump, UInt(1), UInt(0))
  ocmc.io.mcif.start := io.startFill | io.startDump
  // connect fill port to memory read responses, with downsizer in between
  val ds = Module(new AXIStreamDownsizer(64, p.writeWidth))
  io.mem.rsp.ready := ds.io.in.ready
  ds.io.in.valid := io.mem.rsp.valid
  ds.io.in.bits := io.mem.rsp.bits.readData
  ocmc.io.mcif.fillPort <> ds.io.out
  // connect dump port to queue and reducer
  val dumpQ = Module(new Queue(UInt(width = p.readWidth), 16))
  val redFxn: (UInt,UInt)=>UInt = {(a,b) => a+b}
  val reducer = Module(new StreamReducer(p.readWidth, 0, redFxn))
  ocmc.io.mcif.dumpPort <> dumpQ.io.enq
  dumpQ.io.deq <> reducer.io.streamIn
  reducer.io.byteCount := UInt(p.bits/8)
  reducer.io.start := io.startDump
  // connect dump sum register directly to reducer
  io.dumpSum := reducer.io.reduced

  // add request generator for fetching the fill buffer
  val reqgen = Module(new ReadReqGen(ConveyMemParams(), 0))
  reqgen.io.ctrl.start := io.startFill
  reqgen.io.ctrl.throttle := Bool(false)
  reqgen.io.ctrl.baseAddr := io.baseAddr
  reqgen.io.ctrl.byteCount := UInt(p.bits/8)
  // connect to mem port with adapter
  val reqadp = Module(new ConveyMemReqAdp(ConveyMemParams()))
  reqadp.io.genericReqIn <> reqgen.io.reqs
  reqadp.io.conveyReqOut <> io.mem.req

  val fillDone = (io.startFill & ocmc.io.mcif.done)
  val dumpDone = (io.startDump & reducer.io.finished)
  io.done := fillDone | dumpDone

  io.mem.flushReq := Bool(false)
}

class BRAMTest(numPipes: Int) extends Personality(numPipes) {
  // I/O is defined by the base class (Personality)

  // supported instruction values
  val instrFill = UInt(101, width = 64)
  val instrDump = UInt(102, width = 64)

  // register map
  val regindInstr = 0     // instruction selector
  val regindCycles  = 1   // cycle counter, for benchmarking

  def regindFillPtr(i: Int) = {2 + i*3 + 0}
  def regindDumpPtr(i: Int) = {2 + i*3 + 1}
  def regindDumpSum(i: Int) = {2 + i*3 + 2}

  // instantiate and connect main (ops) register file
  val aegRegCount = 2 + 3*numPipes
  val regFile = Module(new RegFile(aegRegCount, 18, 64))
  regFile.io.extIF <> io.disp.aeg
  // plug AEG regfile write enables, will be set when needed
  for(i <- 0 until aegRegCount) {
    regFile.io.regIn(i).valid := Bool(false)
  }
  // plug CSR outputs, unused for this design
  io.csr.readData.bits := UInt(0)
  io.csr.readData.valid := Bool(false)
  io.csr.regCount := UInt(0)

  val p = new OCMParameters(math.pow(2,20).toInt, 32, 1, 2, 3)

  val pipes = Vec.fill(numPipes) { Module(new BRAMTestPipe(p)).io}
  val allFinished = pipes.forall({x: BRAMTestPipeIF => x.done})
  val regAllStartFill = Reg(init = Bool(false))
  val regAllStartDump = Reg(init = Bool(false))

  for(i <- 0 until numPipes) {
    pipes(i).mem <> io.mem(i)
    pipes(i).startFill := regAllStartFill
    pipes(i).startDump := regAllStartDump
    pipes(i).baseAddr := regFile.io.regOut( regindFillPtr(i) )
    regFile.io.regIn( regindDumpSum(i) ).bits := pipes(i).dumpSum
    regFile.io.regIn( regindDumpSum(i) ).valid := pipes(i).done
  }


  // default outputs
  // no exceptions
  io.disp.exception := UInt(0)
  // do not accept instrs
  io.disp.instr.ready := Bool(false)

  // instruction logic for two instructions:
  // - fill BRAM
  // - dump BRAM and sum contents

  // instruction dispatch logic
  val sIdle :: sDecode :: sFill :: sDump :: sFinished :: Nil = Enum(UInt(), 5)
  val regState = Reg(init = UInt(sIdle))

  // cycle count will be written when finished
  val regCycleCount = Reg(init = UInt(0, width = 64))
  regFile.io.regIn(regindCycles).bits := regCycleCount
  when (regState != sIdle) { regCycleCount := regCycleCount + UInt(1) }

  switch(regState) {
      is(sIdle) {
        // accept instruction
        regAllStartFill := Bool(false)
        regAllStartDump := Bool(false)
        io.disp.instr.ready := Bool(true)
        when (io.disp.instr.valid) {
          regState := sDecode
          regCycleCount := UInt(0)
        }
      }

      is(sDecode) {
        when (regFile.io.regOut(regindInstr) === instrFill) {regState := sFill}
        .elsewhen (regFile.io.regOut(regindInstr) === instrDump) {regState := sDump}
        .otherwise {io.disp.exception := UInt(1) }
      }

      is(sFill) {
        // give start signal for fill
        regAllStartFill := Bool(true)
        // wait until done
        when (allFinished) {regState := sFinished}
      }

      is(sDump) {
        // give start signal for fill
        regAllStartDump := Bool(true)
        // wait until done
        when (allFinished) {regState := sFinished}
      }

      is(sFinished) {
        // write cycle count and go back to idle
        regFile.io.regIn(regindCycles).valid := Bool(true)
        regState := sIdle
      }
  }
}
