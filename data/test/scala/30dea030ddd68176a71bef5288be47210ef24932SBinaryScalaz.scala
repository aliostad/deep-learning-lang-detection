package concrete

import scalaz.{Functor, Bind, Pure}
import sbinary.{Format, Reads, Writes, Output}

object SBinaryScalaz {
   // A trivial writer monad around functions Output => ()
  case class WriteM[A](v: A, f: Function1[Output, Unit])

  type Write = WriteM[Unit]

  def read[A](implicit s: Format[A]): Reads[A] = s

  def write[T](t: T)(implicit wr: Writes[T]): Write = WriteM((), o => wr.writes(o, t))

  // Typeclass Instances

  implicit val WriteWritesLol: Writes[Write] = new Writes[Write] {
    def writes(out: sbinary.Output, value: Write) {
      value.f(out)
    }
  }

  implicit val WriteMPure: Pure[WriteM] = new Pure[WriteM] {
    def pure[A](a: => A): WriteM[A] = WriteM(a, (_ => ()))
  }

  implicit val WriteMBind: Bind[WriteM] = new Bind[WriteM] {
    def bind[A, B](ma: WriteM[A], f: A => WriteM[B]): WriteM[B] = {
      val WriteM(b, ab) = f(ma.v)
      WriteM(b, (o => {ma.f(o); ab(o)}))
    }
  }

  implicit val WriteMFunctor: Functor[WriteM] = new Functor[WriteM] {
    def fmap[A, B](r: WriteM[A], f: scala.Function1[A, B]): WriteM[B] = WriteM(f(r.v), r.f)
  }

  implicit val ReadsPure: Pure[Reads] = new Pure[Reads] {
    def pure[A](a: => A): Reads[A] = new Reads[A] {
      def reads(in: sbinary.Input): A = a
    }
  }

  implicit val ReadsBind: Bind[Reads] = new Bind[Reads] {
    def bind[A, B](ra: Reads[A], f: A => Reads[B]): Reads[B] = new Reads[B] {
      def reads(in: sbinary.Input): B = {
        val a = ra.reads(in)
        f(a).reads(in)
      }
    }
  }

  implicit val ReadsFunctor: Functor[Reads] = new Functor[Reads] {
    def fmap[A, B](r: Reads[A], f: A => B): Reads[B] = new Reads[B] {
      def reads(in: sbinary.Input): B = f(r.reads(in))
    }
  }
}
