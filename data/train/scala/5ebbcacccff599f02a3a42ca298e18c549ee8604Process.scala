/**
 *
 */
package fp.streamprocessing

import fp.monad.Monad

/**
 * @author Blues
 *
 */
trait Process[I, O] {
  def apply(s: Stream[I]): Stream[O] = this match {
    case Halt() => Stream()
    case Await(recv, finalizer) => s match {
      case h #:: t => recv(h)(t)
      case _ => finalizer(s) // Stream is empty
    }
    case Emit(h, t) => h.toStream append t(s)
  }

  def map[O2](f: O => O2): Process[I, O2] = this match {
    case Halt() => Halt()
    case Emit(h, t) => Emit(h map f, t map f)
    case Await(recv, fb) => Await(recv andThen (_ map f), fb map f)
  }

  def ++(p: => Process[I, O]): Process[I, O] = this match {
    case Halt() => p
    case Emit(h, t) => emitAll(h, t ++ p)
    case Await(recv, fb) => Await(recv andThen (_ ++ p), fb ++ p)
  }

  def emitAll[I, O](head: Seq[O],
    tail: Process[I, O] = Halt[I, O]()): Process[I, O] =
    tail match {
      case Emit(h2, tl) => Emit(head ++ h2, tl)
      case _ => Emit(head, tail)
    }
  def emit[I, O](head: O,
    tail: Process[I, O] = Halt[I, O]()): Process[I, O] =
    emitAll(Stream(head), tail)

  def flatMap[O2](f: O => Process[I, O2]): Process[I, O2] = this match {
    case Halt() => Halt()
    case Emit(h, t) =>
      if (h.isEmpty) t flatMap f
      else f(h.head) ++ emitAll(h.tail, t).flatMap(f)
    case Await(recv, fb) =>
      Await(recv andThen (_ flatMap f), fb flatMap f)
  }

  def unit[O](o: => O): Process[I, O] = emit(o)
}
case class Emit[I, O](
  head: Seq[O],
  tail: Process[I, O] = Halt[I, O]())
  extends Process[I, O]
case class Await[I, O](
  recv: I => Process[I, O],
  finalizer: Process[I, O] = Halt[I, O]())
  extends Process[I, O]
case class Halt[I, O]() extends Process[I, O]

object Process {
  def monad[I]: Monad[({ type f[x] = Process[I, x] })#f] =
    new Monad[({ type f[x] = Process[I, x] })#f] {
      def unit[O](o: => O): Process[I, O] = Emit(Stream(o))
      def flatMap[O, O2](p: Process[I, O])(
        f: O => Process[I, O2]): Process[I, O2] =
        p flatMap f
    }

//  implicit def toMonadic[I, O](a: Process[I, O]) = monad[I].toMonadic(a)
}