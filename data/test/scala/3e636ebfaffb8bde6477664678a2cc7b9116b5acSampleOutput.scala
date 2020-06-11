package samples

import scala.annotation.tailrec

/**
  * Created by me on 13/12/2016.
  */
case class SampleOutput(inputAndStateOutput: InputAndStateOutput) extends ThreeExamples {

  import inputAndStateOutput._

  def whileLoop(): Unit = {
    var state: State = initialState
    while (true) {
      dump(extract(state))
      state = accept(state, fetchInput())
    }
  }

  def akkaStream(): Unit = {
    flowInput
      .scan(initialState)(accept)
      .map(extract)
      .runForeach(dump)
  }

  def iterator(): Unit = {
    iteratorInput()
      .scanLeft(initialState)(accept)
      .map(extract)
      .foreach(dump)
  }

  override def tailRecursive(): Unit = {
    @tailrec
    def go(state: State): Unit = {
      dump(extract(state))
      go(accept(state, fetchInput()))
    }

    go(initialState)
  }
}
