import scala.math.abs

val tolerance = 0.001

def isCloseEnough(x: Double, y: Double): Boolean = {
  (abs((x - y) / x) / x < tolerance)
}

def fixedPoint(f: Double => Double)(guess: Double) = {

  def iterate(guess: Double): Double = {
    val next = f(guess)
    if (isCloseEnough(guess, next)) next
    else iterate(next)
  }
  iterate(guess)
}

def averageDump(f: Double => Double)(x: Double) = (x + f(x)) / 2

//averageDump(x => x * x, 2)


def sqrt(x: Double) =
//averageDump here is partially evaluated function
  fixedPoint(averageDump(y => x / y))(1)