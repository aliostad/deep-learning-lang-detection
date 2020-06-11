package scala.util

object StreamTransducers {
  sealed trait Process[I, O] {
    import Process._
    def apply(s : Stream[I]) : Stream[O] = this match {
      case Halt() => Stream () 
      case Await(recv) => s match {
        case h #::t => recv(Some(h))(t)
        case xs => recv(None)(xs)
      }
      case Emit(h, t) => h #:: t(s)

    }
      def repeat: Process[I,O] = {
        def go(aProcess: Process[I,O]): Process[I,O] = aProcess match {
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
      case class Emit[I,O](
          head: O,
          tail: Process[I,O] = Halt[I,O]())
        extends Process[I,O]

      case class Await[I,O](
          recv: Option[I] => Process[I,O])
        extends Process[I,O]

      case class Halt[I,O]() extends Process[I,O]
      def emit[I,O](head: O,
                    tail: Process[I,O] = Halt[I,O]()): Process[I,O] =
        Emit(head, tail)

      def liftOne[I, O] (f : I => O) : Process[I, O] =
        Await {
          case Some(i) => Emit(f(i))
          case None => Halt ()
        }
      def lift[I,O](f: I => O): Process[I,O] = liftOne(f).repeat
      def takeWhile[I] (f : I => Boolean) : Process [I, I] = {
          Await[I, I] {
            case Some(i) if f(i) => Emit(i)
            case _ => Halt ()
          }
      }.repeat
      def dropWhile[I] (f : I => Boolean) : Process[I, I] = {
        Await[I, I] {
          case Some(i) if f(i) => Halt ()
          case Some(i) if (!f(i))  => Emit(i)
          case None => Halt ()
        }.repeat
      }
      
      def take[I] (n : Int) : Process[I, I] = {
        def go(acc : Int) : Process[I, I] = {
          Await[I,I] {
            case Some(i) if (acc < n) => Emit(i, go(acc + 1))
            case _ => Halt() 
          }
        }
        go(0)
      }

      def drop[I](n: Int): Process[I,I] = {
        def go(acc : Int) : Process[I, I] = {
          Await[I, I] {
            case Some(i) if (acc >= n) => Emit(i, go(acc + 1))
            case Some(i) if (acc < n) => go(acc + 1)
            case None => Halt ()
          }
        }
        go(0)
      }

      def filter[I](f: I => Boolean): Process[I,I] =
        Await[I,I] {
          case Some(i) if f(i) => emit(i)
          case _ => Halt()
        }.repeat

      def sum : Process[Double, Double] =  {
        def go(acc : Double) : Process[Double, Double] = {
          Await {
            case Some(i) => Emit(i + acc, go(i + acc))
            case None => Halt ()
          }
        }
        go(0.0)
      }
        
  }

}