package samples

import scala.annotation.tailrec

/**
  * Created by me on 13/12/2016.
  */
case class SampleBasic(inputAndState: InputAndState) extends ThreeExamples {

  import inputAndState._

  def whileLoop(): Unit = {
    var state: State = initialState
    while (true) {
      dumpState(state)
      state = accept(state, fetchInput())
    }
  }

  def akkaStream(): Unit = {
    flowInput
      .scan(initialState)(accept)
      .runForeach(dumpState)
  }

  def iterator(): Unit = {
    iteratorInput()
      .scanLeft(initialState)(accept)
  }

  override def tailRecursive(): Unit = {
    @tailrec
    def go(state: State): Unit = {
      dumpState(state)
      go(accept(state, fetchInput()))
    }

    go(initialState)
  }
}
