//package com.yayetee.tuio.examples
//
//import com.yayetee.tuio.{TuioCursor, TuioClient, TuioSymbol, TuioFactory}
//import com.yayetee.Tools
//
///**
// * TuioDump
// *
// * Tuio usage example
// */
//
//class MySymbol(xpos: Double, ypos: Double, angle: Double) extends TuioSymbol(xpos, ypos, angle) {
//	TuioDump.logger.info(this + " created (" + xpos + ", " + ypos + ")")
//
//	override def update(xp: Double, yp: Double, a: Double){
//		super.update(xp, yp, a)
//		TuioDump.logger.info(this + " updated (" + xpos + ", " + ypos + ")")
//	}
//
//	override def remove {
//		TuioDump.logger.info(this + " removed")
//	}
//}
//
//class MyCursor(xpos: Double, ypos: Double) extends TuioCursor(xpos, ypos) {
//	TuioDump.logger.info(this + " created (" + xpos + ", " + ypos + ")")
//
//	override def update(xp: Double, yp: Double){
//		super.update(xp, yp)
//		TuioDump.logger.info(this + " updated (" + xpos + ", " + ypos + ")")
//	}
//
//	override def remove {
//		TuioDump.logger.info(this + " removed")
//	}
//}
//
//object MyFactory extends TuioFactory[MySymbol, MyCursor] {
//	def createSymbol(symbolID: Int, xpos: Double, ypos: Double, angle: Double) = new MySymbol(xpos, ypos, angle)
//
//	def createCursor(xpos: Double, ypos: Double) = new MyCursor(xpos, ypos)
//}
//
//
//
//object TuioDump {
//	def logger = Tools.logger(TuioDump.getClass)
//
//	def main(args: Array[String]){
//		val client = new TuioClient[MySymbol, MyCursor](3333, MyFactory)
//		client.connect
//	}
//}
