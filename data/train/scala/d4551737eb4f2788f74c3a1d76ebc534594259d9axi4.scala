package axi4

import Chisel._

class AXI4LiteMasterIO(addr_width: Int = 32, data_width: Int = 32) extends Bundle {
  val write_address = new WriteAddressChannel(addr_width)
  val write_data = new WriteDataChannel(data_width)
  val write_response = new WriteResponseChannel()
  val read_addr = new ReadAddressChannel(addr_width)
  val read_data = new ReadDataChannel(data_width)
}

class AXI4LiteSlaveIO(addr_width: Int, data_width: Int) extends Bundle {
  val write_address = new WriteAddressChannel(addr_width).flip
  val write_data = new WriteDataChannel(data_width).flip
  val write_response = new WriteResponseChannel().flip
  val read_addr = new ReadAddressChannel(addr_width).flip
  val read_data = new ReadDataChannel(data_width).flip
}

class AXI4Channel(direction: IODirection = OUTPUT) extends Bundle {
    val valid = Bool(direction)
    val ready = Bool(direction).flip()
}

class WriteAddressChannel(addr_width: Int) extends AXI4Channel {
  val addr = Bits(width = addr_width).asOutput
  val prot = Bits(width = 3).asOutput
}

class WriteDataChannel(data_width: Int) extends AXI4Channel {
  val data = Bits(width = data_width).asOutput
  val strb = Bits(width = data_width/8).asOutput 
}

class WriteResponseChannel extends AXI4Channel(INPUT) {
  val resp = Bits(width = 2).asInput
}

class ReadAddressChannel(addr_width: Int) extends AXI4Channel {
  val addr = Bits(width = addr_width).asOutput
  val prot = Bits(width = 3).asOutput
}

class ReadDataChannel(data_width: Int) extends AXI4Channel(INPUT) {
  val data = Bits(width = data_width).asInput
  val resp = Bits(width = 2).asInput
}

// for test
class AXI4LiteSlaveTest extends Module {
  val ADDR_WIDTH = 4
  val DATA_WIDTH = 32
  val io = new Bundle {
    val leds = Bits(OUTPUT, ADDR_WIDTH)
    val axi4_lite_slave = new AXI4LiteSlaveIO(ADDR_WIDTH, DATA_WIDTH)
  }

  // default value
  io.axi4_lite_slave.write_address.ready := Bool(false)
  io.axi4_lite_slave.write_data.ready := Bool(false)
  io.axi4_lite_slave.write_response.valid := Bool(false)
  io.axi4_lite_slave.write_response.resp := UInt(0x0, 2)
  io.axi4_lite_slave.read_addr.ready := Bool(false)
  io.axi4_lite_slave.read_data.valid := Bool(false)
  io.axi4_lite_slave.read_data.data := UInt(0x0, DATA_WIDTH)
  io.axi4_lite_slave.read_data.resp := UInt(0x0, 2)

  val sWaitWriteAddr :: sWaitWriteData :: sWaitReadWriteResponse :: Nil = Enum(UInt(), 3)
  val w_state = Reg(init = UInt(sWaitWriteAddr))

  val write_addr = Reg(init = Bits(0x0, ADDR_WIDTH))
  val write_data = Reg(init = Bits(0x0, DATA_WIDTH))

  io.leds := write_data(ADDR_WIDTH, 0)

  // write value
  when(w_state === sWaitWriteAddr) 
  {
    io.axi4_lite_slave.write_address.ready := Bool(true)

    when(io.axi4_lite_slave.write_address.valid)
    {
      write_addr := io.axi4_lite_slave.write_address.addr

      w_state := sWaitWriteData
    }
  }
  .elsewhen(w_state === sWaitWriteData)
  {
    io.axi4_lite_slave.write_data.ready := Bool(true)
    when(io.axi4_lite_slave.write_data.valid) {
//        io.axi4_lite_slave.write_data.strb
      //TODO have to think about strb 
      // data => 0bf5f5f5f5
      // strb = 4b'1111 => 0bf5f5f5f5
      // strb = 4b'0001 => 0b000000f5
      // strb = 4b'1010 => 0bf500f500
      // 
      // current implementation strb is always 0b1111

      write_data := io.axi4_lite_slave.write_data.data

      w_state := sWaitReadWriteResponse
    }
  }
  .elsewhen(w_state === sWaitReadWriteResponse) 
  {
    //TODO have to implement response(bresp)
    io.axi4_lite_slave.write_response.valid := Bool(true)
    io.axi4_lite_slave.write_response.resp := Bits(0x3, 0x2)
    when(io.axi4_lite_slave.write_response.ready)
    {
      w_state := sWaitWriteAddr
    }
  }

  // read_value
  val sWaitReadAddr :: sWaitReadData :: Nil = Enum(UInt(), 2)
  val r_state = Reg(init = UInt(sWaitReadAddr))

  val read_addr = Reg(init = Bits(0x0, ADDR_WIDTH))
  val read_data = Bits(width = DATA_WIDTH)

  read_data := write_data

  when(r_state === sWaitReadAddr)
  {
    io.axi4_lite_slave.read_addr.ready := Bool(true)
    when(io.axi4_lite_slave.read_addr.valid)
    {
      read_addr := io.axi4_lite_slave.read_addr.addr 
      //TODO think about prot

      r_state := sWaitReadData
    }
    
  }
  .elsewhen(r_state === sWaitReadData)
    {
      io.axi4_lite_slave.read_data.data := read_data
      io.axi4_lite_slave.read_data.valid := Bool(true)
      
      // response ok
      io.axi4_lite_slave.read_data.resp := Bits(0x0, 0x2)

      when(io.axi4_lite_slave.read_data.ready) 
      {
        r_state := sWaitReadAddr
      }
    }
}

class AXI4LiteSlave(addr_width: Int, data_width: Int) extends Module {
  val io = new Bundle {
    val host_data = new Bundle {
      val valid = Bool(OUTPUT)
      val data = Bits(width = data_width).asOutput
      val ready = Bool(INPUT)
    }
    val slave = new AXI4LiteSlaveIO(addr_width, data_width)
  }  

  // default output value
  io.slave.write_address.ready := Bool(false)
  io.slave.write_data.ready := Bool(false)
  io.slave.write_response.valid := Bool(false)
  io.slave.write_response.resp := UInt(0x0, 2)
  io.slave.read_addr.ready := Bool(false)
  io.slave.read_data.valid := Bool(false)
  io.slave.read_data.data := UInt(0x0, data_width)
  io.slave.read_data.resp := UInt(0x0, 2)

  io.host_data.data := Bits(0x0, data_width)
  io.host_data.valid := Bool(false)

  val s_wait_host_ready :: s_wait_write_addr_valid :: s_wait_write_data_valid :: s_wait_write_response_ready  :: Nil = Enum(UInt(), 4)
  val w_state = Reg(init = UInt(s_wait_write_addr_valid))

  val write_addr = Reg(init = Bits(0x0, addr_width))
  val write_data = Reg(init = Bits(0x0, data_width))

  when(w_state === s_wait_host_ready)
  {
    io.host_data.data := write_data
    io.host_data.valid := Bool(true)
    when(io.host_data.ready)
    {
      w_state := s_wait_write_addr_valid
    }
  }
  .elsewhen(w_state === s_wait_write_addr_valid)
  {
    io.slave.write_address.ready := Bool(true)
    
    when(io.slave.write_address.valid)
    {
      write_addr := io.slave.write_address.addr
      w_state := s_wait_write_data_valid
    }
  }
  .elsewhen(w_state === s_wait_write_data_valid)
  {
    io.slave.write_data.ready := Bool(true)
    when(io.slave.write_data.valid)
    {
      //TODO strb
      write_data := io.slave.write_data.data
      w_state := s_wait_write_response_ready
    }
  }
  .elsewhen(w_state === s_wait_write_response_ready)
  {
    io.slave.write_response.resp := Bits(0x0, 2)
    io.slave.write_response.valid := Bool(true)
    when(io.slave.write_response.ready)
    {
      w_state := s_wait_host_ready
    }
  }

}


