import scala.math.abs

val est = 1e-9
def isCloseEnough(x: Double, y: Double) =
  abs(abs((x - y) / y) / y) < est

def fixedPoint(f: Double => Double)(firstGuess: Double): Double = {
  def loop(guess: Double): Double = {
    println("guess : " + guess)
    val next = f(guess)
    if (isCloseEnough(guess, next)) next
    else loop(next)
  }
  loop(firstGuess)
}

def averageDump(f: Double => Double)(x: Double): Double =
  0.5 * (x + f(x))

fixedPoint(averageDump(x => 4 / 2 + 1))(1)
//def sqrt(x: Double): Double = fixedPoint(averageDump(y => x / y))(1)
//sqrt(4)

def sqrtStream(x: Double): Stream[Double] = {
  def improve(guess: Double) = (guess + x / guess) * 0.5
  lazy val guesses: Stream[Double] = 1.0 #:: (guesses map improve)
  guesses
}

def isGoodEnough(g: Double, x: Double) =
  abs((g * g - x) / x) < 1e-9

def sqrt(x: Double) =
  sqrtStream(x).filter(isGoodEnough(_, x)).head

sqrt(0.09)


