import math.abs

object w2 {
  val tolerance = 0.0001

  def isCloseEnough(x: Double, y: Double) =
    abs((x - y) / x) / x < tolerance

  def fixedPoint(f: Double => Double)(firstGuess: Double) = {
    def iterate(guess: Double): Double = {
      println(guess)
      val next = f(guess)
      if (isCloseEnough(guess, next)) next
      else iterate(next)
    }

    iterate(firstGuess)
  }
  def averageDump(f: Double => Double)(x:Double) = (x + f(x))/2
//  def sqrt(x:Double) = fixedPoint(y => x / y)(1)

  def sqrt(x:Double) = fixedPoint(averageDump(y=>x/y))(1)
  sqrt(2)

}