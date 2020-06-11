import math.abs

object exercise{
	var tolerance = 0.0001                    //> tolerance  : Double = 1.0E-4
	def isCloseEnough(x:Double, y:Double) =
		abs((x - y) / x) / x < tolerance  //> isCloseEnough: (x: Double, y: Double)Boolean
		
	def fixedPoint(f: Double => Double)(firstGuess: Double) = {
		def iterate(guess: Double): Double = {
			println("guess:" + guess)
			val next = f(guess)
			if (isCloseEnough(guess, next)) next
			else iterate(next)
		}
		iterate(firstGuess)
	}                                         //> fixedPoint: (f: Double => Double)(firstGuess: Double)Double
	
	fixedPoint(x => 1 + x/2)(4)               //> guess:4.0
                                                  //| guess:3.0
                                                  //| guess:2.5
                                                  //| guess:2.25
                                                  //| guess:2.125
                                                  //| guess:2.0625
                                                  //| guess:2.03125
                                                  //| guess:2.015625
                                                  //| guess:2.0078125
                                                  //| guess:2.00390625
                                                  //| guess:2.001953125
                                                  //| guess:2.0009765625
                                                  //| guess:2.00048828125
                                                  //| res0: Double = 2.000244140625
	
	def averageDump(f: Double => Double)(x: Double) = (x + f(x)) / 2
                                                  //> averageDump: (f: Double => Double)(x: Double)Double
	averageDump(y => y/2)(1)                  //> res1: Double = 0.75
	def sqrt(x: Double) =
		fixedPoint(y => x/y)(0.5)         //> sqrt: (x: Double)Double
	
	def sqrtWithDump(x: Double) =
		fixedPoint(averageDump(y => x/y))(1)
                                                  //> sqrtWithDump: (x: Double)Double
	sqrtWithDump(2)                           //> guess:1.0
                                                  //| guess:1.5
                                                  //| guess:1.4166666666666665
                                                  //| guess:1.4142156862745097
                                                  //| res2: Double = 1.4142135623746899
}