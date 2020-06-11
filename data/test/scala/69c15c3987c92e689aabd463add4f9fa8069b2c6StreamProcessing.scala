package chapters

import chapters.Monads.Monad


/**
  * Created on 2016-05-07.
  */
object StreamProcessing {
  import Process._
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

    // Exercise 15.5
    def |>[O2](p2: Process[O, O2]): Process[I, O2] = p2 match {
        // If the right side is halting then no further processing is needed
      case Halt() => Halt()
        // If the right side is emitting, lets Emit, the next state is the combination of next right state and current left
      case Emit(h, t) => Emit(h, this |> t)
      case Await(recv2) => this match {
        case Halt() => Halt() |> recv2(None)
        case Emit(h, t) => t |> recv2(Some(h))
        case Await(recv1) => Await ((i: Option[I]) => recv1(i) |> p2)
      }
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

    // Exercise 15.6
    def zipWithIndex: Process[I, (O, Int)] = {
      def go(count: Int, in: Process[I, O]): Process[I, (O, Int)] = in match {
        case Halt() => Halt()
        case Emit(h, t) => Emit((h, count), go(count + 1, t))
        case Await(recv) => Await(recv andThen(a => go(count, a)))
      }

      go(0, this)
    }
  }

  object Process {
    case class Emit[I, O](head: O, tail: Process[I, O] = Halt[I, O]()) extends Process[I, O]
    case class Await[I, O](recv: Option[I] => Process[I, O]) extends Process[I, O]
    case class Halt[I, O]() extends Process[I, O]

    def emit[I,O](head: O,
                  tail: Process[I,O] = Halt[I,O]()): Process[I,O] =
      Emit(head, tail)

    /**
      * A helper function to await an element or fall back to another process
      * if there is no input.
      */
    def await[I,O](f: I => Process[I,O],
                   fallback: Process[I,O] = Halt[I,O]()): Process[I,O] =
      Await[I,O] {
        case Some(i) => f(i)
        case None => fallback
      }

    def liftOne[I, O](f: I => O): Process[I, O] =
      Await {
        case Some(i) => Emit(f(i))
        case None => Halt()
      }

    def lift[I, O](f: I => O): Process[I, O] = liftOne(f).repeat

    def filter[I](p: I => Boolean): Process[I, I] = Await[I, I] {
      case Some(i) if p(i) => Emit(i)
      case _ => Halt()
    }.repeat

    def sum: Process[Double, Double] = {
      def go(acc: Double): Process[Double, Double] =
        Await {
          case Some(i) => Emit(acc + i, go(acc + i))
          case _ => Halt()
        }
      go(0.0)
    }

    // Exercise 15.1
    def take[I](n: Int): Process[I, I] = {
      def go(num: Int): Process[I, I] =
        Await {
          case Some(i) if num > 0 => Emit(i, go(num - 1))
          case _ => Halt()
        }
      go(n)
    }

    def drop[I](n: Int): Process[I, I] = {
      def go(num: Int): Process[I, I] =
        Await {
          case Some(i) if num > 0 => go(num - 1)
          case Some(i) => Emit(i, go(num))
          case _ => Halt()
        }
      go(n)
    }

    def takeWhile[I](f: I => Boolean): Process[I, I] =
      Await {
        case Some(i) if f(i) => Emit(i, takeWhile(f))
        case _ => Halt()
      }

    def identity[I]: Process[I, I] =
      Await[I, I] {
        case Some(i) => Emit(i)
        case _ => Halt()
      }.repeat

    def dropWhile[I](f: I => Boolean): Process[I, I] =
      Await {
        case Some(i) if f(i) => dropWhile(f)
        case Some(i) => Emit(i, identity)
        case _ => Halt()
      }

    // Exercise 15.2
    def count[I]:Process[I, Int] = {
      def go(count: Int): Process[I, Int] =
        Await {
          case Some(i) => Emit(count + 1, go(count + 1))
          case _ => Halt()
        }
      go(0)
    }

    // Exercise 15.3
    def mean: Process[Double, Double] = {
      def go(sum: Double, count: Int): Process[Double, Double] =
        Await {
          case Some(i) => Emit((sum + i) / (count + 1), go(sum + i, count + 1))
          case _ => Halt()
        }
      go(0.0, 0)
    }


    def loop[S, I, O](z: S)(f: (I, S) => (O, S)): Process[I, O] =
      await((i: I) => f(i, z) match {
        case (o, s2) => emit(o, loop(s2)(f))
      })

    // Exercise 15.4

    def sum2: Process[Double, Double] = loop(0.0) {
      (i, s) => (s + i, s + i)
    }

    def count2[I]: Process[I, Int] = loop(0) {
      (i, s) => (s + 1, s + 1)
    }

    // Exercise 15.7
    def zip[A, B, C](p1: Process[A, B], p2: Process[A, C]): Process[A, (B, C)] = (p1, p2) match {
      case (Halt(), _) => Halt()
      case (_, Halt()) => Halt()
      case (Emit(b, t1), Emit(c, t2)) => Emit((b, c), zip(t1, t2))
      case (e @ Emit(_, _), Await(recv)) => Await(a => zip(feed(a)(e), recv(a)))
      case (Await(recv), e @ Emit(_, _)) => Await(a => zip(recv(a), feed(a)(e)))
      case (Await(b), Await(c)) => Await((a: Option[A]) => zip(b(a), c(a)))
    }

    def feed[A,B](oa: Option[A])(p: Process[A,B]): Process[A,B] =
      p match {
        case Halt() => p
        case Emit(h,t) => Emit(h, feed(oa)(t))
        case Await(recv) => recv(oa)
      }

    def mean2: Process[Double, Double] =
      zip(count[Double], sum).map {
        case (i, sum) => sum / i
      }

    // Exercise 15.8
    def exists[I](f: I => Boolean): Process[I, Boolean] =
      loop(false) {
        (i, s) => (f(i) || s, f(i) || s)
      }

    def monad[I]: Monad[({ type f[x] = Process[I,x]})#f] =
      new Monad[({ type f[x] = Process[I,x]})#f] {
        def unit[O](o: => O): Process[I,O] = emit[I, O](o)
        override def flatMap[O,O2](p: Process[I,O])(f: O => Process[I,O2]): Process[I,O2] =
          p flatMap f
      }
  }


}
