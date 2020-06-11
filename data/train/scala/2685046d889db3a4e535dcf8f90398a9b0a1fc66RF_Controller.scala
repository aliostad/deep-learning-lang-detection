/**
package rfcontroller

import chisel3._
import chisel3.util._
import utils.Preamble_Generator
import utils.Whitening
import utils.Parallel_Crc
import utils.SyncFifo
	
class Rf_Controller extends Module {
  val io = IO(new Bundle {  
    val dma_rdata                   = Input(UInt(64.W))   			// interface with DMA and Tilelink
    val tilelink_rdata              = Input(UInt(32.W))        
    val dma_wdata                   = Output(UInt(64.W))    
    val load_data_request           = Output(Bool())					   //// The RF_Controller send a request if it needs more data
    val store_data_request          = Output(Bool())
    val load_access_address_request = Output(Bool())
    val dma_done                    = Input(Bool())                        //// The dma receive the request and output new data, as well as the "dma_done" signal
    val tilelink_done               = Input(Bool())

    val tx_load_rf_timer            = Input(Bool())		            // interface with RF_timer
    val tx_send_rf_timer	        = Input(Bool())
    val rx_start_rf_timer	        = Input(Bool())
    val rx_store_rt_timer	        = Input(Bool())

    val modulation_bit_out          = Output(UInt(1.W))             // interface with modulation block
    val modulation_bit_in           = Input(UInt(1.W))
  })

val TX_SLEEP               = "h00".U(8.W)
val TX_INIT                = "h01".U(8.W)
val TX_LOAD_ACCESS_ADDRESS = "h02".U(8.W)
val TX_GENERATE_PREAMBLE   = "h03".U(8.W)
val TX_DMA_WAIT            = "h04".U(8.W)
val TX_LOAD_BYTE0          = "h05".U(8.W)
val TX_LOAD_BYTE1          = "h06".U(8.W)
val TX_LOAD_BYTE2          = "h07".U(8.W)
val TX_LOAD_BYTE3          = "h08".U(8.W)
val TX_LOAD_BYTE4          = "h09".U(8.W)
val TX_LOAD_BYTE5          = "h0a".U(8.W)
val TX_LOAD_BYTE6          = "h0b".U(8.W)
val TX_LOAD_BYTE7          = "h0c".U(8.W)
val TX_LOAD_DONE           = "h0d".U(8.W)
val TX_LOAD_CRC0    	   = "h0e".U(8.W)
val TX_LOAD_CRC1  		   = "h0f".U(8.W)
val TX_LOAD_CRC2  		   = "h10".U(8.W)
val TX_SEND_HEADER 		   = "h11".U(8.W)
val TX_SEND_PDU  	   	   = "h12".U(8.W)
val TX_SEND_DONE  		   = "h13".U(8.W)

    val mode                = Reg(init = 0.U(2.W))				// Mode includes IDLE = 0, TX = 1, RX = 2
    val next_state          = Reg(init = 0.U(8.W))        
    val state               = Reg(next = next_state, init = 0.U(8.W))    
    val access_address_reg  = Reg(init = 0.U(32.W))   
    val preamble_reg        = Reg(init = 0.U(8.W))
    val pdu_reg             = Reg(init = 0.U(128.W))
    val pdu_length          = Reg(init = 0.U(8.W))
    val pdu_counter         = Reg(init = 0.U(8.W))
    val send_counter        = Reg(init = 0.U(9.W))
    val header_length       = 5.U

    val load_pdu_length_done = Reg(init = false.B)

    val preamble  = Module(new Preamble_Generator)
    val whitening = Module(new Whitening)
    val crc       = Module(new Parallel_Crc)
    val fifo      = Module(new SyncFifo)

    next_state := MuxCase(next_state,                                               // state transition
        Array(
            (io.tx_load_rf_timer === true.B)                                        -> TX_INIT,                             //1
            (next_state === TX_INIT)                                                -> TX_LOAD_ACCESS_ADDRESS,              //2
            (io.tilelink_done === true.B)                                           -> TX_GENERATE_PREAMBLE,                //3
            (state === TX_GENERATE_PREAMBLE && preamble.io.result_val === true.B)   -> TX_DMA_WAIT,                         //4
            (state === TX_DMA_WAIT && io.dma_done === true.B)                       -> TX_LOAD_BYTE0,                       //5
            ((next_state === TX_LOAD_BYTE0 && pdu_counter =/= pdu_length + 2.U) || (state === TX_LOAD_BYTE0 && load_pdu_length_done === false.B))        -> TX_LOAD_BYTE1,                       //6
            ((next_state === TX_LOAD_BYTE1 && pdu_counter =/= pdu_length + 2.U) || (state === TX_LOAD_BYTE1 && load_pdu_length_done === false.B))        -> TX_LOAD_BYTE2,                       //7
            (next_state === TX_LOAD_BYTE2 && pdu_counter =/= pdu_length + 2.U)           -> TX_LOAD_BYTE3,                       //8 
            (next_state === TX_LOAD_BYTE3 && pdu_counter =/= pdu_length + 2.U)           -> TX_LOAD_BYTE4,                       //9
            (next_state === TX_LOAD_BYTE4 && pdu_counter =/= pdu_length + 2.U)           -> TX_LOAD_BYTE5,                       //a
            (next_state === TX_LOAD_BYTE5 && pdu_counter =/= pdu_length + 2.U)           -> TX_LOAD_BYTE6,                       //b
            (next_state === TX_LOAD_BYTE6 && pdu_counter =/= pdu_length + 2.U)           -> TX_LOAD_BYTE7,                       //c
            (next_state === TX_LOAD_BYTE7 && pdu_counter =/= pdu_length + 2.U)           -> TX_DMA_WAIT,

            (next_state === TX_LOAD_BYTE0 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,                        //d
            (next_state === TX_LOAD_BYTE1 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,
            (next_state === TX_LOAD_BYTE2 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,
            (next_state === TX_LOAD_BYTE3 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,
            (next_state === TX_LOAD_BYTE4 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,
            (next_state === TX_LOAD_BYTE5 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,
            (next_state === TX_LOAD_BYTE6 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,
            (next_state === TX_LOAD_BYTE7 && pdu_counter === pdu_length + 2.U)           -> TX_LOAD_DONE,     
            (next_state === TX_LOAD_DONE  && crc.io.result_val === true.B)               -> TX_LOAD_CRC0,                        //e
            (state === TX_LOAD_CRC0)                                                -> TX_LOAD_CRC1,                        //f
            (state === TX_LOAD_CRC1)                                                -> TX_LOAD_CRC2,                        //10
            (state === TX_LOAD_CRC2)                                                -> TX_SEND_HEADER,                      //11
            (state === TX_SEND_HEADER && send_counter === header_length)            -> TX_SEND_PDU,                         //12
            (state === TX_SEND_PDU && send_counter === header_length + pdu_length)  -> TX_SEND_DONE,                        //13
            (state === TX_SEND_DONE)                                                -> TX_SLEEP                             //0
        )
    )      

    //Load access_address from Tilelink
    io.load_access_address_request := MuxLookup(state, false.B,
        Array(
            TX_LOAD_ACCESS_ADDRESS -> true.B
        )
    )

    access_address_reg := MuxLookup(io.tilelink_done, access_address_reg,
        Array(
            true.B -> io.tilelink_rdata
        )
    )
 	
    //Preamble Generator I/O
    preamble.io.access_address_in := access_address_reg

    preamble.io.operand_val := MuxLookup(next_state, false.B,
        Array(
            TX_GENERATE_PREAMBLE -> true.B
        )
    )

    preamble.io.result_rdy := true.B

    preamble_reg := MuxLookup(preamble.io.result_val, preamble_reg,
        Array(
            true.B -> preamble.io.preamble_out
        )
    )
    
    //DMA interface

    io.load_data_request := MuxLookup(state, false.B,
        Array(
            TX_DMA_WAIT  -> true.B
        )
    )
    
    when (state === TX_LOAD_BYTE1 && load_pdu_length_done === false.B) {
        pdu_length := io.dma_rdata(15,8)
        load_pdu_length_done := true.B
    }

    pdu_counter := MuxLookup(state, pdu_counter,
        Array(
            TX_LOAD_BYTE0   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE1   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE2   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE3   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE4   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE5   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE6   -> (pdu_counter + 1.U),
            TX_LOAD_BYTE7   -> (pdu_counter + 1.U)
        )
    )
    
    pdu_reg := MuxLookup(state, pdu_reg,
        Array(
            TX_LOAD_BYTE0 -> Cat(pdu_reg(119,0),io.dma_rdata(7,0)),
            TX_LOAD_BYTE1 -> Cat(pdu_reg(119,0),io.dma_rdata(15,8)),
            TX_LOAD_BYTE2 -> Cat(pdu_reg(119,0),io.dma_rdata(23,16)),
            TX_LOAD_BYTE3 -> Cat(pdu_reg(119,0),io.dma_rdata(31,24)),
            TX_LOAD_BYTE4 -> Cat(pdu_reg(119,0),io.dma_rdata(39,32)),
            TX_LOAD_BYTE5 -> Cat(pdu_reg(119,0),io.dma_rdata(47,40)),
            TX_LOAD_BYTE6 -> Cat(pdu_reg(119,0),io.dma_rdata(55,48)),
            TX_LOAD_BYTE7 -> Cat(pdu_reg(119,0),io.dma_rdata(63,56))
        )
    )
}
*/
