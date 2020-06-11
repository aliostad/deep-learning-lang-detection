package io.github.facaiy.fp.scala.c15

import io.github.facaiy.fp.scala.c11.Monad

/**
 * Created by facai on 6/21/17.
 */
sealed trait Process[I, O] {
  import Process._

  def apply(s: Stream[I]): Stream[O] = this match {
    case Halt() => Stream()
    case Await(recv) => s match {
      case h #:: t => recv(Some(h))(t)
      case xs => recv(None)(xs)
    }
    case Emit(h, t) => h #:: t(s)
  }

  def repeat: Process[I, O] = {
    /**
     * restart Halt().
     */
    def go(p: Process[I, O]): Process[I, O] = p match {
      case Halt() => go(this)
      case Await(recv) => Await {
        case None => recv(None)
        case x => go(recv(x))
      }
      case Emit(h, t) => Emit(h, go(t))
    }

    go(this)
  }

  // ex 15.5
  def |>[O2](p2: Process[O, O2]): Process[I, O2] = (this, p2) match {
    case (Halt(), _) => Halt()
    case (_, Halt()) => Halt()
    case (_, Emit(g, t)) => Emit(g, this |> t)
    case (Await(r), _) => Await((o: Option[I]) => r(o) |> p2)
    case (Emit(h, t), Await(r2)) => t |> r2(Some(h))
  }

  def map[O2](f: O => O2): Process[I, O2] = this |> lift(f)

  def ++(p: => Process[I, O]): Process[I, O] = this match {
    case Halt() => p
    case Emit(h, t) => Emit(h, t ++ p)
    case Await(recv) => Await(recv andThen (_ ++ p))
  }

  def flatMap[O2](f: O => Process[I, O2]): Process[I, O2] = this match {
    case Halt() => Halt()
    case Emit(h, t) => f(h) ++ t.flatMap(f)
    case Await(recv) => Await(recv andThen (_.flatMap(f)))
  }

  // ex 15.6
  def zipWithIndex: Process[I, (O, Int)] = {
    def go(n: => Int): Process[O, (O, Int)] =
      liftOne[O, (O, Int)](x => (x, n)) ++ go(n + 1)

    this |> go(0)
  }
}

object Process {
  def liftOne[I, O](f: I => O): Process[I, O] = Await {
    case Some(x) => Emit(f(x))
    case None => Halt()
  }

  def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

  def filter[I](p: I => Boolean): Process[I, I] = Await[I, I] {
    case Some(x) if p(x) => Emit[I, I](x)
    case _ => Halt()
  }.repeat

  // ex 15.1
  def take[I](n: Int): Process[I, I] =
    if (n <= 0) Halt()
    else Await {
      case Some(x) => Emit(x, take(n - 1))
      case None => Halt()
    }

  def drop[I](n: Int): Process[I, I] =
    if (n <= 0) lift(x => x)
    else Await {
      case Some(x) => drop(n - 1)
      case None => Halt()
    }

  def takeWhile[I](f: I => Boolean): Process[I, I] =
    Await {
      case Some(x) if f(x) => Emit(x, takeWhile(f))
      case _ => Halt()
    }

  def dropWhile[I](f: I => Boolean): Process[I, I] =
    Await {
      case Some(x) =>
        if (f(x)) dropWhile(f)
        else Emit(x, lift(y => y))
      case None => Halt()
    }

  // ex 15.2
  /*
  def count[I]: Process[I, Int] = {
    def go(index: Int): Process[I, Int] =
      Emit(index,
        Await[I, Int] {
          case Some(_) => go(index + 1)
          case None => Halt()
        })

    go(0)
  }
  */

  // ex 15.3
  /*
  def mean: Process[Double, Double] = {
    def go(sum: Double, num: Int): Process[Double, Double] =
      Await[Double, Double] {
        case Some(x) =>
          val sumN = sum + x
          val numN = num + 1
          Emit(sumN / numN, go(sumN, numN))
        case None => Halt()
      }

    go(0, 0)
  }
  */
  def mean: Process[Double, Double] =
    loop((0.0, 0.0)){ (i, s) =>
      val sum = s._1 + i
      val num = s._2 + 1

      (sum / num, (sum, num))
    }
  // ex 15.7
  /**
   * wrong implementation.
  def mean: Process[Double, Double] = for {
    s <- sum
    c <- count
  } yield s / c
  */

  def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] =
    Await[I, O] {
      case Some(i) => f(i, z) match {
        case (o, s2) => Emit(o, loop(s2)(f))
      }
      case None => Halt()
    }

  // ex 15.4
  def sum: Process[Double, Double] =
    loop(0.0)((i, s) => (i + s, i + s))

  def count[I]: Process[I, Int] =
    loop(0)((_, n) => (n + 1, n + 1))

  def monad[I] = new Monad[({type f[x] = Process[I, x]})#f] {
    override def unit[A](a: => A): Process[I, A] = Emit[I, A](a)
    override def flatMap[A, B](fa: Process[I, A])(f: (A) => Process[I, B]): Process[I, B] = fa flatMap f
  }
}

case class Emit[I, O](head: O,
                      tail: Process[I, O] = Halt[I, O]()) extends Process[I, O]

case class Await[I, O](recv: Option[I] => Process[I, O]) extends Process[I, O]

case class Halt[I, O]() extends Process[I, O]
