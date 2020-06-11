package BFSBackend

import Chisel._
import Literal._
import Node._
import AXIStreamDefs._
import AXIDefs._
import Constants._

class WriteGenerator() extends Module {
  val io = new Bundle {
    // control interface
    val start = Bool(INPUT)
    val basePtr = UInt(INPUT, 32)

    // status output
    val state = UInt(OUTPUT, 32)
    val writeCount = UInt(OUTPUT, 32)

    // write data input
    val writeDataIn = new AXIStreamSlaveIF(UInt(width = mmapDataBits))

    // AXI MM outputs
    val writeAddrOut   = Decoupled(new AXIAddress(addrBits, idBits))
    val writeDataOut   = Decoupled(new AXIWriteData(mmapDataBits))
    val writeRespIn   = Decoupled(new AXIWriteResponse(idBits)).flip
  }

  val regWriteCount = Reg(init=UInt(0,32))
  val regWritePtr = Reg(init=UInt(0,32))
  val regWriteData = Reg(init=UInt(0, mmapDataBits))

  val sIdle :: sFetch :: sReq :: sSend :: sWaitResp :: Nil = Enum(UInt(), 5)
  val regState = Reg(init=UInt(sIdle))


  // default outputs
  // state outputs
  io.state := regState
  io.writeCount := regWriteCount
  // write data in and response in channels
  io.writeDataIn.ready := Bool(false)
  io.writeRespIn.ready := Bool(false)
  // write address channel - the parts that change
  io.writeAddrOut.valid := Bool(false)
  io.writeAddrOut.bits.addr := regWritePtr
  // write address channel - the parts that remain constant
  io.writeAddrOut.bits.id := UInt(0)  // no multiple transactions
  io.writeAddrOut.bits.len := UInt(0) // len 0 is single burst beat
  io.writeAddrOut.bits.prot := UInt(0)
  io.writeAddrOut.bits.qos := UInt(0)
  io.writeAddrOut.bits.lock := Bool(false)
  io.writeAddrOut.bits.cache := UInt("b0010") // no alloc, modifiable, no buffer
  io.writeAddrOut.bits.size := UInt(log2Up((mmapDataBits/8)-1)) // full data width
  io.writeAddrOut.bits.burst := UInt(1) // incrementing burst
  // write data channel
  io.writeDataOut.valid := Bool(false)
  io.writeDataOut.bits.data := regWriteData
  io.writeDataOut.bits.strb := UInt("b11111111")  // all bytelanes valid
  io.writeDataOut.bits.last := Bool(true)  // single beat burst - always "last" beat

  // TODO improve write performance:
  // - use write bursts instead of single beat
  // - do not wait on response

  switch(regState) {
      is(sIdle) {
        regWritePtr := io.basePtr
        when (io.start) {
          regWriteCount := UInt(0)
          regState := sFetch
        }
      }

      is(sFetch) {
        // fetch data from input data queue and put into register
        io.writeDataIn.ready := Bool(true)
        regWriteData := io.writeDataIn.bits

        when (!io.start) {
          regState := sIdle
        }
        .elsewhen (io.writeDataIn.valid) {
          regState := sReq
        }
      }

      is(sReq) {
        // data ready, let's issue the write request
        io.writeAddrOut.valid := Bool(true)

        when (io.writeAddrOut.ready) {
          // increment the write pointer
          regWritePtr := regWritePtr + UInt(mmapDataBits/8)
          regState := sSend
        }
      }

      is(sSend) {
        // dispatch the data
        io.writeDataOut.valid := Bool(true)

        when (io.writeDataOut.ready) {
          regState := sWaitResp
        }
      }

      is(sWaitResp) {
        // wait for write complete response
        io.writeRespIn.ready := Bool(true)

        when (io.writeRespIn.valid) {
          // increment write counter
          regWriteCount := regWriteCount + UInt(1)
          regState := sFetch
        }
      }
  }


}
