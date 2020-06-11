package me.jeffshaw.scalaz.stream

import scalaz.concurrent.Task
import scalaz.stream.Process

object IteratorConstructors {

  /**
   * Create a Process from an iterator. This should not be used directly,
   * because iterators are mutable.
   */
  private [stream] def iteratorGo[O](iterator: Iterator[O]): Process[Task, O] = {
    val hasNext = Task delay { iterator.hasNext }
    val next = Task delay { iterator.next() }

    def go: Process[Task, O] = Process.await(hasNext) { hn => if (hn) Process.eval(next) ++ go else Process.halt }

    go
  }

  implicit def ProcessToProcessIteratorConstructors(x: Process.type): ProcessIteratorConstructors.type = {
    ProcessIteratorConstructors
  }

  implicit def ProcessIoToProcessIoIteratorConstructors(x: scalaz.stream.io.type): ProcessIoIteratorConstructors.type = {
    ProcessIoIteratorConstructors
  }

}
