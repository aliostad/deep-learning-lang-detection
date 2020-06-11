import Chapter11._

object Chapter15 {
  sealed trait Process[I,O] {
    import Process._

    val M = monad[I]

    def apply(s: Stream[I]): Stream[O] = this match {
      case Halt() => Stream()
      case Await(recv) => s match {
        case h #:: t => recv(Some(h))(t)
        case xs => recv(None)(xs)
      }
      case Emit(h,t) => h #:: t(s)
    }

    def ++(p: => Process[I,O]): Process[I,O] = this match {
      case Halt() => p
      case Emit(h, t) => Emit(h, t ++ p)
      case Await(recv) => Await(recv andThen (_ ++ p))
    }

    def flatMap[O2](f: O => Process[I,O2]): Process[I,O2] = this match {
      case Halt() => Halt()
      case Emit(h, t) => f(h) ++ t.flatMap(f)
      case Await(recv) => Await(recv andThen (_ flatMap f))
    }

    def repeat: Process[I,O] = {
      def go(p: Process[I,O]): Process[I,O] = p match {
        case Halt() => go(this)
        case Await(recv) => Await {
          case None => recv(None)
          case i => go(recv(i))
        }
        case Emit(h, t) => Emit(h, go(t))
      }
      go(this)
    }

    def |>>>>[O2](p2: Process[O,O2]): Process[I,O2] = {
      (this, p2) match {
        case (Halt(), _) | (_, Halt()) => Halt()
        case (_, Emit(o2,t2)) => Emit(o2, this |> t2)
        case (Emit(o, t), Await(recv)) => t |> recv(Some(o))
        case (Await(recv), _) => Await(i => recv(i) |> p2)
      }
    }


   // Correct answer (my answer didn't handle Halt() on this correctly)
   /*
    * Exercise 5: Implement `|>`. Let the types guide your implementation.
    */
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

    def map[O2](f: O => O2): Process[I,O2] = this |> lift(f)

    def zipWithIndex: Process[I,(O,Int)] = M.product(this,count)
  }

  object Process {
    implicit def monad[I]: Monad[({ type f[x] = Process[I,x] })#f] =
      new Monad[({ type f[x] = Process[I,x] })#f] {
        def unit[O](o: => O): Process[I,O] = Emit(o)
        def flatMap[O,O2](p: Process[I,O])(
            f: O => Process[I,O2]): Process[I,O2] =
          p flatMap f
      }

    def liftOne[I,O](f: I => O): Process[I,O] =
      Await {
        case Some(i) => Emit(f(i))
        case None => Halt()
      }

    def lift[I,O](f: I => O): Process[I,O] = liftOne(f).repeat

    def take[I](n: Int): Process[I,I] = {
      if (n <= 0)
        Halt()
      else
        Await {
          case Some(i) => Emit(i, take(n-1))
          case None => Halt()
        }
    }

    def takeWhile[I](f: I => Boolean): Process[I,I] = {
      Await {
        case Some(i) if f(i) => Emit(i, takeWhile(f))
        case _ => Halt()
      }
    }

    def count[I]: Process[I,Int] = {
      def loop(n: Int): Process[I,Int] = {
        Await {
          case Some(i) => Emit(n, loop(n+1))
          case None => Halt()
        }
      }
      loop(1)
    }

    def mean: Process[Double,Double] = {
      def loop(sum: Double, count: Int): Process[Double,Double] = {
        Await {
          case Some(i) => Emit((sum+i)/(count+1), loop(sum+i,count+1))
          case None => Halt()
        }
      }
      loop(0, 0)
    }

    def loop[S,I,O](z: S)(f: (I,S) => (O,S)): Process[I,O] =
      Await {
        case Some(i) => f(i,z) match {
          case (o,s2) => Emit(o, loop(s2)(f))
        }
        case None => Halt()
      }

    def count1[I]: Process[I,Int] =
      loop(0)((i,count) => (count,count+1))

    def sum[I]: Process[Int,Int] =
      loop(0)((i,s) => (s+i,s+i))

    def drop[I](n: Int): Process[I,I] = {
      Await {
        case Some(i) => {
          if (n > 0)
            drop(n-1)
          else
            Emit(i, drain)
        }
        case None => Halt()
      }
    }

    def dropWhile[I](f: I => Boolean): Process[I,I] = {
      Await {
        case Some(i) => {
          if (f(i))
            dropWhile(f)
          else
            Emit(i, drain)
        }
        case None => Halt()
      }
    }

    def drain[I]: Process[I,I] = {
      Await {
        case Some(i) => Emit(i, drain)
        case None => Halt()
      }
    }

    def filter[I](p: I => Boolean): Process[I,I] =
      Await[I,I] {
        case Some(i) if p(i) => Emit(i)
        case _ => Halt()
      }.repeat
  }

  case class Emit[I,O](
      head: O,
      tail: Process[I,O] = Halt[I,O]())
    extends Process[I,O]

  case class Await[I,O](
      recv: Option[I] => Process[I,O])
    extends Process[I,O]

  case class Halt[I,O]() extends Process[I,O]
}
