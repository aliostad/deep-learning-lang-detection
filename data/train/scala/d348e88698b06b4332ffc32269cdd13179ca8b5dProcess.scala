package com.github.kczulko.chapter15

import com.github.kczulko.chapter11.Monad

sealed trait Process[I,O] {
  def apply(s: Stream[I]): Stream[O] = {
    this match {
      case Halt() => Stream()
      case Await(recv) => s match {
        case h #:: t => recv(Some(h))(t)
        case xs => recv(None)(xs)
      }
      case Emit(h,t) => h #:: t(s)
    }
  }

  def repeat: Process[I,O] = {
    def loop(p: Process[I,O]): Process[I,O] = p match {
      case Halt() => loop(this)
      case Await(recv) => Await {
        case None => recv(None)
        case i => loop(recv(i))
      }
      case Emit(h,t) => Emit(h, loop(t))
    }
    loop(this)
  }

  def |>[O2](other: Process[O,O2]): Process[I,O2] = other match {
    case Halt() => Halt()
    case Emit(h,t) => Emit(h, this |> t)
    case Await(f) => this match {
      case Halt() => this |> f(None)
      case Emit(h,t) => t |> f(Some(h))
      case Await(r) => Await[I,O2](i => r(i) |> other)
    }
  }

  def map[O2](f: O => O2): Process[I,O2] = this |> Process.lift(f)

  def ++(other: Process[I,O]): Process[I,O] = this match {
    case Halt() => other
    case Emit(h,t) => Emit(h, t ++ other)
    case Await(f) => Await(io => f(io) ++ other)
  }

  def flatMap[O2](f: O => Process[I,O2]): Process[I,O2] = this match {
    case Halt() => Halt()
    case Emit(h,t) => f(h) ++ t.flatMap(f)
    case Await(r) => Await(io => r(io).flatMap(f))
  }

  def zipWithIndex: Process[I,(O,Int)] = {
    def loop(n: Int, p: Process[I,O]): Process[I,(O,Int)] = p match {
      case Emit(h,t) => Emit((h, n), loop(n+1,t))
      case Await(r) => Await(oi => loop(n, r(oi)))
      case Halt() => Halt()
    }
    loop(0, this)
  }

  def zipWithIndex2: Process[I,(O,Int)] = Process.zip(this, Process.count.map(_ - 1))
}

case class Emit[I,O](head: O, tail: Process[I,O] = Halt[I,O]()) extends Process[I,O]
case class Await[I,O](recv: Option[I] => Process[I,O]) extends Process[I,O]
case class Halt[I,O]() extends Process[I,O]

object Process {
  def liftOne[I,O](f: I => O): Process[I,O] = Await {
    case Some(i) => Emit[I,O](f(i))
    case None => Halt()
  }

  def lift[I,O](f: I => O): Process[I,O] = liftOne(f) repeat

  def filter[I](p: I => Boolean): Process[I,I] =
    Await[I,I] {
      case Some(i) if p(i) => Emit[I,I](i)
      case _ => Halt()
    } repeat

  def exists[I](p: I => Boolean): Process[I,Boolean] =
    Await[I,Boolean] {
      case Some(i) => if (p(i)) Emit[I,Boolean](true) else Emit(false, exists(p))
      case _ => Halt()
    }

  def sum: Process[Double,Double] = loop(0.0)((i,s) => (i + s, i + s))

  def take[I](n: Int): Process[I,I] = n match {
    case 0 => Halt()
    case _ => Await[I,I] {
      case Some(i) => Emit[I,I](i, take(n - 1))
      case _ => Halt()
    }
  }

  def drop[I](n: Int): Process[I,I] = n match {
    case 0 => lift(identity)
    case _ => Await[I,I] {
      case Some(_) => drop(n - 1)
      case _ => Halt()
    }
  }

  def takeWhile[I](p: I => Boolean): Process[I,I] =
    Await[I,I] {
      case Some(i) if p(i) => Emit(i, takeWhile(p))
      case _ => Halt()
    }

  def dropWhile[I](p: I => Boolean): Process[I,I] =
    Await[I,I] {
      case Some(i) if p(i) => dropWhile(p)
      case Some(i) if !p(i) => Emit(i, lift(identity))
      case _ => Halt()
    }

  def count[I]: Process[I,Int] = loop(0)((_,s) => (s + 1, s + 1))

  def mean: Process[Double,Double] =
    loop((0.0, 0))({
      case (cur, (acc, idx)) => ((cur + acc)/(idx + 1), (acc + cur, idx + 1))
    })

  def loop[S,I,O](z: S)(f: (I,S) => (O,S)): Process[I,O] = {
    Await {
      case Some(i) => f(i,z) match {
        case (o,s2) => Emit(o, loop(s2)(f))
      }
      case _ => Halt()
    }
  }

  def monad[I]: Monad[(({type f[x] = Process[I,x]}))#f] = new Monad[({type f[x] = Process[I, x]})#f] {
    override def flatMap[O, O2](ma: Process[I, O])(f: (O) => Process[I, O2]): Process[I,O2] = ma flatMap f
    override def unit[O](a: => O) = Emit(a)
  }

  def zip[I,O1,O2](first: Process[I,O1], second: Process[I,O2]): Process[I,(O1,O2)] = (first, second) match {
    case (Emit(h1,t1), Emit(h2,t2)) => Emit((h1,h2), zip(t1, t2))
    case (Emit(_,_), Await(r)) => Await(oi => zip(first, r(oi)))
    case (Await(r), Emit(_,_)) => Await(oi => zip(r(oi), second))
    case (Await(r1), Await(r2)) => Await(oi => zip(r1(oi), r2(oi)))
    case (_,_) => Halt()
  }
}
