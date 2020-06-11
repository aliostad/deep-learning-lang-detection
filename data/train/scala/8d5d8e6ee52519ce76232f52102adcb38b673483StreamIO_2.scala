package streamio

// reflects the code changes upon MEAP-14

trait Process[I,O] {
    def apply(s: Stream[I]) : Stream[O] = this match {
        case Halt() => Stream()
        case Await(recv) => s match {
            case h #:: t => recv(Some(h))(t)
            case xs => recv(None)(xs)
        }
        case Emit(h,t) => h #:: t(s)
    }

    def liftOne[I,O](f: I => O): Process[I,O] = 
        Await{
            case Some(i) => Emit(f(i))
            case None => Halt()
        }

    def repeat : Process[I,O] = {
        def go(p: Process[I,O]) : Process[I,O] = p match {
            case Halt() => go(this)
            case Await(recv) => Await {
                case None => recv(None)
                case i => go(recv(i))
            }
            case Emit(h,t) => Emit(h, go(t))
        }
        go(this)
    }

    def take[I](n: Int) : Process[I,I] = {
        def go(c: Int) : Process[I,I] = Await {
        case Some(i) if c != 0 => Emit(i, go(c-1))
        case Some(i) if c == 0 => Halt()
        case None => Halt()
        }
        go(n)
    }

    def takeWhile[Int](f: I => Boolean) : Process[I,I] = {
        def go : Process[I,I] = 
		    Await[I,I]{
		        case Some(i) if f(i) => Emit(i, go)
		        case Some(i) if !f(i) => Halt()
		        case _ => Halt()
		    }
        go
    }
    def drop[I](n: Int) : Process[I,I] = {
        def go(c: Int) : Process[I,I]  = Await {
            case Some(i) if c == 0 => Emit(i, go(c))
            case None => Halt() // you need this here else `go(c)` will go into a infinite loop
            case _ => go(c - 1)
        }
        go(n)
    }

    def count : Process[I,Long] = {
        def go(acc: Long) : Process[I,Long] = 
        Await[I,Long] {
            case Some(i) => Emit(acc+1, go(acc+1))
            case None => Halt()
        }
        go(0)
    }

    def loop[S,I,O](z: S)(f: (I,S) ⇒ (O,S)) : Process[I,O] = 
        Await((i:Option[I]) ⇒ f(i.get,z) match {
            case (o,s2) ⇒ Emit(o, loop(s2)(f))
        })
    def mean : Process[I,Float] = {
        import scala.math._
        def go(acc: Float) : Process[I,Float] = 
        Await[I,Float] {
            case Some(f:Float) => Emit((abs _ compose round)((acc+f)/2), go(acc+f))
            case None => Halt()
        }
        go(0.0f)
    }

    def dropWhile[Int](f: I => Boolean) : Process[I,I] = {
        def go : Process[I,I] = 
		    Await[I,I]{
                case Some(i) if !f(i) => Emit(i, go)
		        case Some(i) if f(i) => Halt()
		        case None => Halt()
		    }
        go
    }

    def sum : Process[Double,Double] = {
        def go(acc: Double) : Process[Double,Double] = Await {
            case Some(i) => Emit(i + acc, go(i+acc))
            case None => Halt()
        }
        go(0.0)
    }

    def filter[I](p: I => Boolean) : Process[I,I] = 
        Await[I,I] {
            case Some(i) if p(i) => Emit(i)
            case _ => Halt()
        }.repeat

    def lift[I,O](f: I => O) = liftOne(f).repeat
}

case class Emit[I,O](head: O, tail: Process[I,O] = Halt[I,O]()) extends Process[I,O]

case class Halt[I,O]() extends Process[I,O]

case class Await[I,O](recv: Option[I] => Process[I,O]) extends Process[I,O]

object TestP extends App {

    def liftOne[I,O](f: I => O): Process[I,O] = 
        Await{
            case Some(i) => Emit(f(i))
            case None => Halt()
        }

    val p = liftOne((x: Int) ⇒ x * x )
    val xs = p(Stream(1,2,3)).toList

    println(s"xs is ${xs}")
}

