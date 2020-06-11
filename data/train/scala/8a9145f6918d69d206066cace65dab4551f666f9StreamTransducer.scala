package learn.fpscala.exercise.chapter15


sealed trait Process[I, O] {
  def apply(s: Stream[I]): Stream[O] = this match {
    case Halt() => Stream()
    case Await(recv) => s match {
      case h #:: t => recv(Some(h))(t)
      case xs => recv(None)(xs)
    }
    case Emit(h, t) => h #:: t(s)
  }

  def repeat: Process[I, O] = {
    def go(p: Process[I, O]): Process[I, O] = p match {
      case Halt() => go(this)
      case Await(recv) => Await {
        case None => recv(None)
        case i => go(recv(i))
      }
      case Emit(h, t) => Emit(h, go(t))
    }

    go(this)
  }
}

object Process {
  def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

  def liftOne[I, O](f: I => O): Process[I, O] =
    Await {
      case Some(i) => Emit(f(i))
      case None => Halt()
    }

  def id[I]: Process[I, I] = lift(identity)

  def filter[I](p: I => Boolean): Process[I, I] =
    Await[I, I] {
      case Some(i) if p(i) => Emit[I, I](i)
      case _ => Halt()
    }.repeat

  def sum: Process[Double, Double] = {
    def go(acc: Double): Process[Double, Double] =
      Await {
        case Some(d) => Emit(d + acc, go(d + acc))
        case None => Halt()
      }

    go(0.0)
  }

  def await[I, O](f: I => Process[I, O],
                  fallback: Process[I, O] = Halt[I, O]()): Process[I, O] =
    Await[I, O] {
      case Some(i) => f(i)
      case None => fallback
    }

  def emit[I, O](h: O, t: Process[I, O] = Halt[I, O]()): Process[I, O] = Emit(h, t)

  def takeBook[I](n: Int): Process[I, I] =
    if (n <= 0) Halt()
    else await(i => emit(i, take[I](n - 1))) //It's ok

  def take[I](n: Int): Process[I, I] =
    Await[I, I] {
      case Some(i) if n > 0 => Emit[I, I](i, take(n - 1))
      case _ => Halt()
    }

  def takeWhile[I](condition: I => Boolean): Process[I, I] =
    Await[I, I] {
      case Some(i) if condition(i) => Emit[I, I](i, takeWhile(condition))
      case _ => Halt()
    }

  def drop[I](n: Int): Process[I, I] =
    if (n <= 0) id //lift(x => x)
    else await(i => drop[I](n - 1))

  def dropWhile[I](f: I => Boolean): Process[I, I] =
    await(i =>
      if (f(i)) dropWhile(f)
      else emit(i, id))

  def count[I]: Process[I, Int] = {
    def go(from: Int): Process[I, Int] =
      await(i =>
        emit(from, go(from + 1))
      )

    go(0)
  }

  def mean[I]: Process[Double, Double] = {
    def go(sum: Double, count: Double): Process[Double, Double] =
      await((d: Double) => emit((sum + d) / (count + 1), go(sum + d, count + 1)))

    go(0.0, 0.0)
  }

  def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] =
    await((i: I) => f(i, z) match {
      case (o, s2) => emit(o, loop(s2)(f))
    })
}

case class Emit[I, O](
                       head: O,
                       tail: Process[I, O] = Halt[I, O]())
  extends Process[I, O]

case class Await[I, O](
                        recv: Option[I] => Process[I, O])
  extends Process[I, O]

case class Halt[I, O]() extends Process[I, O]

class StreamTransducer {

}
