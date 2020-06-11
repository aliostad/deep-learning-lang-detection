package chapter15

import scala.collection.immutable.Stream.#::

trait Process[I,O] {
  def apply(s: Stream[I]): Stream[O] = this match {
    case Halt() => Stream()
    case Await(recv) => s match {
      case h #:: t => recv(Some(h))(t)
      case xs => recv(None)(xs)
    }
    case Emit(h,t) => h #:: t(s)
  }
}

case class Emit[I,O](
  head: O,
  tail: Process[I,O] = Halt[I,O]())
  extends Process[I,O]

case class Await[I,O](
  receive: Option[I] => Process[I,O])
  extends Process[I,O]

case class Halt[I,O]() extends Process[I,O]
