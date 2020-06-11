package SICP.Chapter1

/**
 * Created by Jonathan Taylor on 29/03/2014.
 */
object CubeRoot {

  def cubeRoot(x: Double) = {
    def goodEnough(guess: Double) = Math.abs(guess * guess * guess - x) < 0.001
    def improve(y: Double) = ((x / (y * y)) + (2 * y)) / 3
    def loop(guess: Double): Double = if (goodEnough(guess)) guess else loop(improve(guess))
    loop(1.0)
  }

  private def showResult(x: Double) = {
    println("cubeRoot(%f): %f".format(x, cubeRoot(x)))
  }

  def main(args: Array[String]) = {
    showResult(1 * 1 * 1)
    showResult(2 * 2 * 2)
    showResult(3 * 3 * 3)
    showResult(4 * 4 * 4)
    showResult(5 * 5 * 5)
    showResult(6 * 6 * 6)
    showResult(7 * 7 * 7)
    showResult(8 * 8 * 8)
    showResult(9 * 9 * 9)
    showResult(10 * 10 * 10)
  }
}
