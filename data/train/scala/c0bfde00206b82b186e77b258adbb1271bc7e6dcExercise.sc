import math.abs

object exercise {
  val tolerance = 0.0001
  def isCloseEnough(x:Double, y:Double) =
    abs((x-y)/x)/x < tolerance
  def fixedPoint(f:Double => Double)(FirstGuess: Double) = {
    def iterate(guess: Double): Double = {
      println(guess)
      val next = f(guess)
      if(isCloseEnough(guess,next)) next
      else iterate(next)
    }
    iterate(FirstGuess)
  }
  fixedPoint(x => 1 + x/2)(1)
  def averageDump(f:Double => Double)(x:Double): Double = (x + f(x)) / 2

  def sqrt(x:Double) = fixedPoint(averageDump(y => x/y))(1)
  //def sqrt(x:Double) = fixedPoint(y => ((x + y)/y) / 2)(1)
  sqrt(2)
}