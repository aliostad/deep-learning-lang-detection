package kkalc.service

import scalaz.concurrent.Task
import scalaz.stream._

package object simulation {
  protected val P = Process

  implicit class ConcurrentProcess[O](val process: Process[Task, O]) {
    /**
     * Run process through channel with given level of concurrency
     */
    def concurrently[O2](concurrencyLevel: Int)(f: Channel[Task, O, O2]): Process[Task, O2] = {
      val actions =
        process.
          zipWith(f)((data, f) => f(data))

      val nestedActions =
        actions.map(P.eval)

      merge.mergeN(concurrencyLevel)(nestedActions)
    }
  }
}