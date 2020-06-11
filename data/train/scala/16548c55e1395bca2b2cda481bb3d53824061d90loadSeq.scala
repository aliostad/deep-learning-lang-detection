package HyperCell

import Chisel._
import HyperCellParams.GlobalConfig._
import HyperCellParams.LoadSeqConfig._

class loadSeq extends Module{
	val io 	= new Bundle{
		val inConfig			= UInt(INPUT, width = dataWidth)
		val inValid			= Bool(INPUT)
		
		val loadRqst			= UInt(OUTPUT, width = lrReqFifoWidth)
		val loadRqstValid		= Bool(OUTPUT)
		val loadRqstRdy			= Bool(INPUT)
		
		val loadResp			= UInt(INPUT, width = lrRespFifoWidth)
		val loadRespValid		= Bool(INPUT)
		val loadRespRdy			= Bool(OUTPUT)
		
		val memBankEnq			= Vec.fill(memBanks){UInt(OUTPUT, (memWidth + memAddrWidth))}
		val memBankValid		= Vec.fill(memBanks){Bool(OUTPUT)}
		val memBankRdy			= Vec.fill(memBanks){Bool(INPUT)}
		
	}
	
	val loadCtrlClass			= Module(new loadSeqCtrl())
	val loadDPClass				= Module(new loadSeqDP())
	
	loadCtrlClass.io.inConfig		:= io.inConfig
	loadCtrlClass.io.inValid		:= io.inValid
	
	loadDPClass.io.inConfig			:= io.inConfig
	loadDPClass.io.inValid			:= io.inValid
	
	io.loadRqst				:= loadDPClass.io.loadRqst
	io.loadRqstValid			:= loadDPClass.io.loadRqstValid
	loadDPClass.io.loadRqstRdy		:= io.loadRqstRdy
	
	loadDPClass.io.loadResp			:= io.loadResp
	loadDPClass.io.loadRespValid		:= io.loadRespValid
	io.loadRespRdy				:= loadDPClass.io.loadRespRdy
	
	
	loadCtrlClass.io.seqProceed		:= loadDPClass.io.seqProceed
	
	loadDPClass.io.spillEnd			:= loadCtrlClass.io.spillEnd
	loadDPClass.io.nextIterStart		:= loadCtrlClass.io.nextIterStart
	loadDPClass.io.seqMemAddr		:= loadCtrlClass.io.seqMemAddr
	loadDPClass.io.seqMemAddrValid		:= loadCtrlClass.io.seqMemAddrValid
	
	loadDPClass.io.memBankRdy		:= io.memBankRdy
	io.memBankEnq				:= loadDPClass.io.memBankEnq
	io.memBankValid				:= loadDPClass.io.memBankValid
	
	
	
}


//class loadSeqTest(c: loadSeq) extends Tester(c){	
//	val range : Int = (scala.math.pow(2, 30)).toInt
//	var i0  : Int = 0x4007e4a1
//	
//      
//	poke(c.io.inConfig, i0)
//	poke(c.io.inValid, 0x1)
//	poke(c.io.loadRqstRdy, 0x1)
//	poke(c.io.loadResp, 0x98293429)
//	poke(c.io.loadRespValid, 0x0)
//	for(i<-0 until memBanks){
//		poke(c.io.memBankRdy(i), 0x1)
//	}
//	step(1)
//	
//	for(t<-0 until 5){
//		var i1  : Int = rnd.nextInt(range) + 0x80000000
//		poke(c.io.inConfig, i1)
//		peek(c.loadCtrlClass.prologueDepth)
//		peek(c.loadCtrlClass.steadyStateDepth)
//		peek(c.loadCtrlClass.epilogueDepth)
//		peek(c.loadCtrlClass.epilogueSpill)
//		peek(c.loadCtrlClass.iterCount)
//		step(1)
//	}
//}
//		

//object loadSeqMain {
//    def main(args: Array[String]) {
//	chiselMainTest(Array[String]("--backend", "c", "--genHarness",  "--debug", "--compile", "--test"),
//	() => Module(new loadSeq())){c => new loadSeqTest(c)}
//    }
//}

//object loadSeqMain {
//    def main(args: Array[String]) {
//    
//    	chiselMain(Array[String]("--backend", "v"),
//	() => Module(new loadSeq()))

//    }
//}

