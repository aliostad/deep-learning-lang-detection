package primers.phasers

import edu.rice.habanero.HabaneroHelper._
import edu.rice.habanero.{PhaserMode, Operator, HabaneroApp}

object IterativeAveragingAccumulatorApp extends HabaneroApp {

  println("IterativeAveragingAccumulatorApp starting...")

  val n: Int = 10
  println("IterativeAveragingAccumulatorApp: creating array of size: " + (n + 1))
  val newDataArray = new Array[Double](n + 2)
  val dataArray = new Array[Double](n + 2)

  println("IterativeAveragingAccumulatorApp: initializing array")
  for (i <- 0 to n) {
    dataArray(i) = 0
    newDataArray(i) = 0
  }
  dataArray(n + 1) = 1
  newDataArray(n + 1) = 1

  println("IterativeAveragingAccumulatorApp: input data array = " + dataArray.deep.mkString(" "))

  val epsilon = 1e-6
  var iters = 0

  finish {
    var delta = epsilon + 1
    val ph = phaser(PhaserMode.SIG_WAIT_SINGLE)
    val ac = doubleAccumulator(Operator.SUM, ph)
    var jj = 1
    while (jj <= n) {
      val j = jj
      asyncPhased(ph) {
        // local data pointers
        var newArray = newDataArray
        var oldArray = dataArray

        while (delta > epsilon) {
          newArray(j) = (oldArray(j - 1) + oldArray(j + 1)) / 2.0f
          val diff = math.abs(newArray(j) - oldArray(j))
          ac.send(diff)
          // local work overlapped with accumulator operations
          next {
            // barrier with single statement, only one arbitrary task executes this
            delta = ac.result()
            iters += 1
          }
          // switch around references for next phase
          val temp = newArray
          newArray = oldArray
          oldArray = temp
        }
      }
      jj += 1
    }
  }
  println("IterativeAveragingAccumulatorApp: iterations = " + iters)
  val resultArray = if (iters % 2 == 0) {
    newDataArray
  } else {
    dataArray
  }
  println("IterativeAveragingAccumulatorApp: averaged data array = " + resultArray.deep.mkString(" "))

  println("IterativeAveragingAccumulatorApp ends.")

}
