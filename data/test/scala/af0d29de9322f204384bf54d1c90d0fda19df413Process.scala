package functionalProgramming.chapter4.lazyio

import functionalProgramming.chapter3.applicative.Monad

sealed trait Process[I, O] {self =>
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

/*  def |>[O2](p2: Process[O,O2]): Process[I,O2] = new Process[I,O2] {
    override def apply(s: Stream[I]): Stream[O2] = p2.apply(self(s))

    n'est pas une solution puisqu'elle fera en fait 2 transformations => ce n'est pas ce que veut
  }*/

  def |>[O2](p2: Process[O,O2]): Process[I,O2] = {
    p2 match {
      case Halt() => Halt()
      case Emit(h,t) => Emit(h, this |> t)
      case Await(f) => this match {
        case Emit(h,t) => t |> f(Some(h))
        case Halt() => Halt() |> f(None)
        case Await(g) => Await((i: Option[I]) => g(i) |> p2)
      }
    }
  }

  def map[O2](f: O => O2): Process[I,O2] = this |> Process.lift(f)

  def ++(p: => Process[I,O]): Process[I,O] = this match {
    case Halt() => p
    case Emit(h,t) => Emit(h, t ++ p)
    case Await(recv) => Await(recv andThen ( _ ++ p))
  }

  def flatMap[O2](f: O => Process[I,O2]): Process[I,O2] = this match {
    case Halt() => Halt()
    case Emit(h,t) => f(h) ++ t.flatMap(f)
    case Await(recv) => Await(recv andThen (_ flatMap f))
  }

/*  def zipWithIndex: Process[I,(O,Int)] = {
    def go(n : Int, p: Process[I,O]): Process[I,(O,Int)] =
      p match {
        case Halt() => Halt()
        case Emit(h,t) => Emit((h,n), go(n+1, t))
        case Await(f) => Await(f andThen (go(n+1, _)))
      }
    go(0,this)
  }*/

  /** Exercise 7: see definition below. */
  def zip[O2](p: Process[I,O2]): Process[I,(O,O2)] =
    Process.zip(this, p)

  /*
   * Exercise 6: Implement `zipWithIndex`.
   */
  def zipWithIndex: Process[I,(O,Int)] =
    this zip (Process.count map (_ - 1))
}

case class Emit[I, O](head: O, tail: Process[I, O] = Halt[I, O]()) extends Process[I, O]

case class Await[I, O](recv: Option[I] => Process[I, O]) extends Process[I, O]

case class Halt[I, O]() extends Process[I, O]


object Process {
  def liftOne[I, O](f: I => O): Process[I, O] =
    Await {
      case Some(i) => Emit(f(i))
      case None => Halt()
    }

  def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

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

  def take[I](n: Int): Process[I, I] = {
    def go(x: Int): Process[I, I] =
      if (x == 0) Halt() else Await {
        case Some(i) => Emit(i, go(x - 1))
        case None => Halt()
      }

    go(n)
  }

  def drop[I](n: Int): Process[I, I] = {
    def go(x: Int): Process[I, I] =
      if (x > 0) Await {
        case Some(_) => go(x - 1)
        case None => Halt()
      } else Await {
        case Some(i) => Emit(i, go(x))
        case None => Halt()
      }

    go(n)
  }

  def takeWhile[I](f: I => Boolean): Process[I, I] = Await {
    case Some(i) if f(i) => Emit(i, takeWhile(f))
    case _ => Halt()
  }

  def dropWhile[I](f: I => Boolean): Process[I, I] = {
    def end: Process[I, I] = Await {
      case Some(i) => Emit(i, end)
      case None => Halt()
    }

    Await {
      case Some(i) if f(i) => dropWhile(f)
      case Some(i) => Emit(i, end)
      case None => Halt()
    }
  }

  def count[I]: Process[I, Int] = {
    def go(n: Int): Process[I, Int] =
      Await {
        case Some(_) => Emit(n, go(n + 1))
        case None => Halt()
      }

    go(1)
  }

  def mean: Process[Double, Double] = {
    def go(l: List[Double]): Process[Double, Double] =
      Await {
        case Some(d) => Emit((d :: l).sum / (l.length + 1), go(d :: l))
        case None => Halt()
      }

    go(List())
  }

  def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] =
    Await {
      case Some(i) => f(i, z) match {
        case (o, s2) => Emit(o, loop(s2)(f))
      }
      case None => Halt()
    }

  def sum_ : Process[Double, Double] = {
    loop(0.0)((i,s) => (i+s,i+s))
  }

  def count_[I]: Process[I, Int] = {
    loop(1)((_, s) => (s,s+1))
  }

  def monad[I]: Monad[({type f[x] = Process[I,x]})#f] = new Monad[({type f[x] = Process[I, x]})#f] {

    override def unit[O](o: => O): Process[I, O] = Emit(o)
    override def flatMap[O, O2](p: Process[I, O])(f: (O) => Process[I, O2]): Process[I, O2] = p flatMap f
  }

  def zip[A,B,C](p1: Process[A,B], p2: Process[A,C]): Process[A,(B,C)] =
    (p1, p2) match {
      case (Halt(), _) => Halt()
      case (_, Halt()) => Halt()
      case (Emit(b, t1), Emit(c, t2)) => Emit((b,c), zip(t1, t2))
      case (Await(recv1), _) =>
        Await((oa: Option[A]) => zip(recv1(oa), feed(oa)(p2)))
      case (_, Await(recv2)) =>
        Await((oa: Option[A]) => zip(feed(oa)(p1), recv2(oa)))
    }

  def feed[A,B](oa: Option[A])(p: Process[A,B]): Process[A,B] =
    p match {
      case Halt() => p
      case Emit(h,t) => Emit(h, feed(oa)(t))
      case Await(recv) => recv(oa)
    }

}