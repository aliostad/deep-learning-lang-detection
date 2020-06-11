package byexample

import scala.math._

object FirstClassFunctions {
  
  def sum(f: Int => Int)(a: Int, b: Int): Int = {
    def iter(a: Int, result: Int): Int = {
      if (a > b) result
      else iter(a + 1, result + f(a))
    }
    iter(a, 0)
  }                                               //> sum: (f: Int => Int)(a: Int, b: Int)Int
  
  sum(x => x * x)(1, 5)                           //> res0: Int = 55
  
  val tolerance = 0.0001                          //> tolerance  : Double = 1.0E-4
  def isCloseEnough(x: Double, y: Double) = abs((x - y) / x) < tolerance
                                                  //> isCloseEnough: (x: Double, y: Double)Boolean
  def fixedPoint(f: Double => Double)(firstGuess: Double) = {
    def iterate(guess: Double): Double = {
      val next = f(guess)
      if (isCloseEnough(guess, next)) next
      else iterate(next)
    }
    iterate(firstGuess)
  }                                               //> fixedPoint: (f: Double => Double)(firstGuess: Double)Double
  
  def sqrt(x: Double) = fixedPoint(y => (y + x/y)/2)(1.0)
                                                  //> sqrt: (x: Double)Double
  sqrt(2)                                         //> res1: Double = 1.4142135623746899
  
  def averageDump(f: Double => Double)(x: Double) = (x + f(x)) / 2
                                                  //> averageDump: (f: Double => Double)(x: Double)Double
  def sqrt2(x: Double) = fixedPoint(averageDump(y => x/y))(1.0)
                                                  //> sqrt2: (x: Double)Double
  sqrt2(2)                                        //> res2: Double = 1.4142135623746899
  
  def curt(x: Double) = fixedPoint(averageDump(y => x / (y*y)))(1.0)
                                                  //> curt: (x: Double)Double
  curt(27)                                        //> res3: Double = 3.0000885780097266
  
}