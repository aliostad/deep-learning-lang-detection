package chapter_15

import chapter_11.Monad
import chapter_13.IO
import chapter_15.Process._

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

  def |>[O2](p2: Process[O, O2]): Process[I, O2] = p2 match {
    case Halt() => Halt()
    case Emit(h, t) => Emit(h, this |> t)
    case Await(f) => this match {
      case Halt() => this |> f(None)
      case Emit(h, t) => t |> f(Some(h))
      case Await(f2) => Await[I, O2](i => f2(i) |> p2)
    }
  }

  def map[O2](f: O => O2): Process[I, O2] = this |> lift(f)

  def ++(p: => Process[I, O]): Process[I, O] = this match {
    case Halt() => p
    case Emit(h, t) => Emit(h, t ++ p)
    case Await(f) => Await(f.andThen(_ ++ p))
  }

  def flatMap[O2](f: O => Process[I, O2]): Process[I, O2] = this match {
    case Halt() => Halt()
    case Emit(h, t) => f(h) ++ t.flatMap(f)
    case Await(recv) => Await(recv(_).flatMap(f))
  }

  def zip[O2](p2: Process[I, O2]): Process[I, (O, O2)] = this -> p2 match {
    case (Halt(), _) => Halt()
    case (_, Halt()) => Halt()
    case (Emit(h1, t1), Emit(h2, t2)) => Emit((h1, h2), t1.zip(t2))
    case (Await(f1), _) => Await[I, (O, O2)](o => f1(o).zip(feed(o)(p2)))
    case (_, Await(f1)) => Await[I, (O, O2)](o => feed(o)(this).zip(f1(o)))
  }

  def zipWithIndex: Process[I, (O, Int)] = this zip count

  def orElse(p: Process[I, O]): Process[I, O] = this match {
    case Halt() => p
    case Await(f) => Await {
      case None => p
      case i => f(i)
    }
    case _ => this
  }
}

case class Emit[I, O](head: O, tail: Process[I, O] = Halt[I, O]()) extends Process[I, O]

case class Await[I, O](recv: Option[I] => Process[I, O]) extends Process[I, O]

case class Halt[I, O]() extends Process[I, O]

object Process {

  def await[I, O](f: I => Process[I, O], fallback: Process[I, O] = Halt[I, O]()) = Await[I, O] {
    case Some(i) => f(i)
    case _ => fallback
  }

  def emit[I, O](head: O, tail: Process[I, O] = Halt[I, O]()): Emit[I, O] = Emit[I, O](head, tail)

  def liftOne[I, O](f: I => O): Process[I, O] =
    Await {
      case Some(i) => Emit[I, O](f(i))
      case None => Halt()
    }

  def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

  def filter[I](p: I => Boolean): Process[I, I] =
    await[I, I](i => if (p(i)) emit(i) else Halt()).repeat

  def sum: Process[Double, Double] = {
    def go(acc: Double): Process[Double, Double] =
      await(d => emit(d + acc, go(d + acc)))
    go(0.0)
  }

  def take[I](n: Int): Process[I, I] = {
    if (n <= 0) Halt()
    else await(a => emit(a, take(n - 1)))
  }

  def drop[I](n: Int): Process[I, I] = {
    await { a =>
      if (n <= 0) emit(a, drop(n))
      else drop(n - 1)
    }
  }

  def takeWhile[I](f: I => Boolean): Process[I, I] = {
    await { a =>
      if (f(a)) emit(a, takeWhile(f))
      else Halt()
    }
  }

  def dropWhile[I](f: I => Boolean): Process[I, I] = {
    await { a =>
      if (!f(a)) emit(a, dropWhile(_ => false))
      else dropWhile(f)
    }
  }

  def count[I]: Process[I, Int] = {
    def go(cnt: Int): Process[I, Int] =
      await(d => emit(cnt, go(cnt + 1)), Emit(cnt))
    go(0)
  }

  def mean: Process[Double, Double] = {
    def go(cnt: Int, sum: Double): Process[Double, Double] =
      await(d => emit((sum + d) / (cnt + 1), go(cnt + 1, sum + d)))
    go(0, 0)
  }

  def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] =
    await { i =>
      val (o, s2) = f(i, z)
      emit(o, loop(s2)(f))
    }

  def sum_2: Process[Double, Double] =
    loop(0.0)((x, acc) => (x + acc, x + acc))

  def count_2[I]: Process[I, Int] =
    loop(0)((_, acc) => (acc + 1, acc + 1))

  def count_3[I]: Process[I, Int] =
    lift[I, Double](_ => 1.0) |> sum |> lift(_.toInt)

  val evenPlus5 = filter[Int](_ % 2 == 0) |> lift(_ + 5)

  def monad[I]: Monad[({type f[x] = Process[I, x]})#f] =
    new Monad[({type f[x] = Process[I, x]})#f] {
      def unit[O](o: => O): Process[I, O] =
        emit[I, O](o)

      def flatMap[O, O2](p: Process[I, O])(f: O => Process[I, O2]): Process[I, O2] =
        p.flatMap(f)
    }

  def feed[A, B](a: Option[A])(p: Process[A, B]): Process[A, B] = p match {
    case Halt() => Halt()
    case Emit(h, t) => Emit(h, feed(a)(t))
    case Await(r) => r(a)
  }

  def echo[I]: Process[I, I] = await(i => emit(i))

  def mean_2: Process[Double, Double] = count_2[Double] zip sum map (x => x._2 / x._1)

  def exists[I](f: I => Boolean): Process[I, Boolean] = lift(f) |> loop(false)((i, s) => (i || s) -> (s || i))

  def exists_2[I](f: I => Boolean): Process[I, Boolean] = lift(f) |> dropWhile(!_) |> echo.orElse(emit(false))

  def processFile[A, B](f: java.io.File,
                        p: Process[String, A],
                        z: B)(g: (B, A) => B): IO[B] = IO {
    @annotation.tailrec
    def go(ss: Iterator[String], cur: Process[String, A], acc: B): B =
      cur match {
        case Halt() => acc
        case Await(recv) =>
          val next = if (ss.hasNext) recv(Some(ss.next))
          else recv(None)
          go(ss, next, acc)
        case Emit(h, t) => go(ss, t, g(acc, h))
      }
    val s = io.Source.fromFile(f)
    try go(s.getLines, p, z)
    finally s.close
  }

  def toCelsius(fahrenheit: Double): Double =
    (5.0 / 9.0) * (fahrenheit - 32.0)

}