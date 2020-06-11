package core

import chisel3._

class ByPassBridge extends Module{
	val io = IO(new Bundle {
		val IR = Input(UInt(width=32))
		val rs1_bypass_mux_sel = Output(UInt(width = 1))
		val rs2_bypass_mux_sel = Output(UInt(width = 1))
		//val IR_old = UInt(0,32)
	})
	
	val IR_old = Reg(next = io.IR)

	when ((IR_old(6,2) === UInt(8,5)) || (IR_old(6,2) === UInt(24,5))){

	} .otherwise {
		
		when (((io.IR(6,2) === UInt(25,5)) || (io.IR(2,2) === UInt(0,1))) && (IR_old(7) || IR_old(8) || IR_old(9) || IR_old(10) || IR_old(11))) {
			when (IR_old(11,7) === io.IR(19,15)){
				io.rs1_bypass_mux_sel := UInt(1,1)
			}.otherwise {
				io.rs1_bypass_mux_sel := UInt(0,1)
			}
		}
		
		when ((io.IR(6,2) === UInt(24,5) ) || (io.IR(6,5) === UInt(1,2)) && (IR_old(7) || IR_old(8) || IR_old(9) || IR_old(10) || IR_old(11))) {
			when (IR_old(11,7) === io.IR(24,20)){
				io.rs2_bypass_mux_sel := UInt(1,1)
			}.otherwise {
				io.rs2_bypass_mux_sel := UInt(0,1)
			}
		}
	}
}
