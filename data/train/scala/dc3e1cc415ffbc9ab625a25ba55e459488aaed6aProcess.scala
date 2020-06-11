package com.promindis.fp

import scala.annotation.tailrec

sealed trait Process[I,O] {
  def map[O2](f: O => O2): Process[I, O2] = Process.map(this)(f)

  def ++(other: Process[I, O]): Process[I, O] = Process.append(this)(other)

  def |>[O2](p2: Process[O, O2]): Process[I, O2] = Process.compose(this)(p2)

  def repeat = Process.repeat(this)
}

case class Emit[I,O](head: Seq[O], tail: Process[I,O] = Halt[I,O]()) extends Process[I,O]

case class Await[I,O](recv: I => Process[I,O], finalizer: Process[I,O] = Halt[I,O]()) extends Process[I,O]

case class Halt[I,O]() extends Process[I,O]

object Process {
  def map[I, O, O2](pa: Process[I, O])(f: O => O2): Process[I, O2] =
    pa match {
      case Halt() => Halt()
      case Await(recv, finalizer) => Await(recv andThen { p => map(p)(f)}, map(finalizer)(f))
      case Emit(head, tail) => Emit(head map f, map(tail)(f))
    }

  def flatMap[I, O, O2](pa: Process[I, O])(f: O => Process[I, O2]): Process[I, O2] =
    pa match {
      case Halt() => Halt()
      case Emit(h, t) if h.isEmpty => flatMap(t)(f)
      case Emit(h, t)  => append(f(h.head))(flatMap(emitAll(h.tail, t))(f))
      case Await(recv, finalizer) => Await((i:I) => flatMap(recv(i))(f), flatMap(finalizer)(f))
    }

  def append[I,O](p1: Process[I,O])(p2: Process[I,O]): Process[I,O] =
    p1 match {
      case Halt() => p2
      case Await(recv, finalizer) => Await((i: I) => append(recv(i))(p2), append(finalizer)(p2))
      case Emit(head, tail) => emitAll(head, append(tail)(p2))
    }

  private def emitAll[I, O](head: Seq[O], tail: Process[I, O]): Process[I,O] =
    tail match {
      case Emit(h2, t) => Emit(head ++ h2, t)
      case _ => Emit(head, tail)
    }

  def emit[I,O](head: O, tail: Process[I,O] = Halt[I,O]()): Process[I,O] =
    emitAll(scala.Stream(head), tail)

  def unit[I, O](o: => O): Process[I,O] = emit(o)

  def monad[I] = new Monad[({type lambda[O] = Process[I,O]})#lambda] {
    def flatMap[O, O2](pa: Process[I,O])(f: (O) => Process[I, O2]) = Process.flatMap(pa)(f)

    def unit[O](o: => O) = Process.unit(o)
  }

//  implicit def toMonadic[I,O](a: Process[I,O]) = monad[I].toMonadic(a)

  def compose[I, O, O2](p1: Process[I,O])(p2: Process[O, O2]): Process[I, O2] = {
    @tailrec
    def feed(s: Seq[O], tail: Process[I, O], recv: O => Process[O, O2], f: Process[O, O2]): Process[I, O2]  = {
      if (s.isEmpty) compose(tail)(Await(recv, f))
      else recv(s.head) match {
        case Await(recv2, f2) => feed(s.tail, tail, recv2, f2)
        case p => compose(Emit(s.tail, tail))(p)
      }
    }

    p2 match {
      case Halt() => Halt()
      case Emit(h, t) => Emit(h, compose(p1)(t))
      case Await(recvb, fb) => p1 match {
        case h @ Halt() => compose(h)(fb)
        case Await(recva, fa) => Await((i:I) => compose(recva(i))(p2), compose(fa)(fb))
        case Emit(s, tail) => feed(s, tail, recvb, fb)
      }
    }
  }

  def repeat[I,O](p: Process[I,O]): Process[I,O]  =
    p match {
      case h @ Halt() => repeat(h)
      case Await(recv, fn) => Await(recv andThen repeat, fn)
      case Emit(h, tail) => Emit(h, repeat(tail))
    }

  def sum(acc: Double = 0d): Process[Double, Double] =
    Await{(n: Double) => emit(acc + n, sum(n + acc)) }

  def filter[I](p: I => Boolean): Process[I,I] = repeat(Await{ (i:I) => if (p(i)) emit(i) else Halt() })

  def take[I](limit: Int): Process[I,I] =
    if (limit == 0) Halt()
    else Await{(i: I) => emit(i, take(limit - 1))}

  def drop[I](limit: Int): Process[I,I] =
    if (limit > 0) Await{ (_: I) => drop(limit - 1)}
    else Await(emit(_, drop(0)))

  def echo[I]: Process[I, I] = Await(emit(_, echo))

}

trait Processes {
  def fold[I, O](s: scala.Stream[I])(p: Process[I, O]): scala.Stream[O]  =
    p match {
      case Halt() => scala.Stream()
      case Await(recv, finalizer) => s match {
        case h #:: t => fold(t)(recv(h))
        case _ => fold(s)(finalizer)
      }
      case Emit(h, t) => h.toStream append(fold(s)(t))
    }
}

object DriveProcess extends Processes {
  def from(n: Int): scala.Stream[Int] = n #:: from(n + 1)

  def main(args: Array[String]) {
//    println(fold(scala.Stream.fill(9999)(1d))(Process.sum(0)).toList)
    println(fold(from(0))(Process.take(5)).toList)
    println(fold(from(0))(Process.drop(5)).toList)
    println(fold(from(0))(Process.echo).take(5).toList)
  }
}