package pl.edu.agh.workflow_processes.simple

import pl.edu.agh.actions.{ActionConverter, Outs}

object ProcessDsl {
  implicit class SetProcessProperties[T, R](process: Process[T, R]) {
    def name(name: String): Process[T, R] = {
      process._name = name
      process
    }
    def outputs(outs: Seq[String]): Process[T, R] = {
      process._outs = outs
      process
    }
    def outputs(outs: Product): Process[T, R] = {
      process._outs = outs.productIterator.toList.map(_.toString)
      process
    }
    def numOfOuts(numOfOuts: Int): Process[T, R] = {
      process._numOfOuts = numOfOuts
      process
    }
    def action(action: (T, Outs) => Unit): Process[T, R] = {
      process._action = ActionConverter(action)
      process
    }
    def action(action: T => Outs => Unit): Process[T, R] = {
      process._action = ActionConverter(action)
      process
    }
  }
}
