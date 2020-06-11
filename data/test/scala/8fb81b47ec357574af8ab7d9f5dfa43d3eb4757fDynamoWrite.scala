package dynamo.ast.writes

import cats.ContravariantCartesian
import cats.functor.Contravariant
import dynamo.ast._

trait DynamoWrite[-A] {
  def write(a: A): DynamoType
}

object DynamoWrite extends PrimitiveWrite with CollectionWrite {
  def apply[A](implicit write: DynamoWrite[A]): DynamoWrite[A] = write

  implicit val contravariantWrites: Contravariant[DynamoWrite] = new Contravariant[DynamoWrite] {
    override def contramap[A, B](fa: DynamoWrite[A])(f: (B) => A): DynamoWrite[B] = new DynamoWrite[B]{
      override def write(b: B) = fa.write(f(b))
    }
  }

  def write[A]: WriteAt[A] = new WriteAt[A]
  class WriteAt[A] {
    def at(path: String)(implicit dynamoWrite: DynamoWrite[A]): DynamoMWrite[A] = new DynamoMWrite[A] {
      override def write(a: A): M = M(List(path -> dynamoWrite.write(a)))
    }
  }

  def writeOpt[A]: WriteOptAt[A] = new WriteOptAt[A]
  class WriteOptAt[A] {
    def at(path: String)(implicit dynamoWrite: DynamoWrite[A]): DynamoMWrite[Option[A]] = new DynamoMWrite[Option[A]]{
      override def write(aOpt: Option[A]): M = aOpt.fold(M(Nil))(a => M(List(path -> dynamoWrite.write(a))))
    }
  }
}

trait DynamoMWrite[-A] extends DynamoWrite[A] {
  def write(a: A): M
}

object DynamoMWrite {
  implicit val contravariant: ContravariantCartesian[DynamoMWrite] = new ContravariantCartesian[DynamoMWrite] {
    override def product[A, B](fa: DynamoMWrite[A], fb: DynamoMWrite[B]): DynamoMWrite[(A, B)] = new DynamoMWrite[(A, B)] {
      override def write(a: (A, B)): M = {
        val as = fa.write(a._1).elements.toMap
        val bs = fb.write(a._2).elements.toMap
        M((as ++ bs).toList)
      }
    }

    override def contramap[A, B](fa: DynamoMWrite[A])(f: (B) => A): DynamoMWrite[B] = new DynamoMWrite[B] {
      override def write(b: B): M = fa.write(f(b))
    }
  }
}

trait PrimitiveWrite {
  implicit object StringWrite extends DynamoWrite[String] {
    override def write(a: String): S = S(a)
  }

  implicit object IntWrite extends DynamoWrite[Int] {
    override def write(a: Int): N = N(a.toString)
  }

  implicit object ShortWrite extends DynamoWrite[Short] {
    override def write(a: Short): N = N(a.toString)
  }

  implicit object LongWrite extends DynamoWrite[Long] {
    override def write(a: Long): N = N(a.toString)
  }

  implicit object FloatWrite extends DynamoWrite[Float] {
    override def write(a: Float): N = N(a.toString)
  }

  implicit object DoubleWrite extends DynamoWrite[Double] {
    override def write(a: Double): N = N(a.toString)
  }

  implicit object BooleanWrite extends DynamoWrite[Boolean] {
    override def write(a: Boolean): BOOL = BOOL(a)
  }
}

trait CollectionWrite { self: PrimitiveWrite =>

  implicit def ListWrite[A](implicit ra: DynamoWrite[A]): DynamoWrite[List[A]] = new DynamoWrite[List[A]] {
    override def write(as: List[A]): DynamoType = L(as.map(ra.write))
  }

  implicit def SetWriteString: DynamoWrite[Set[String]] = new DynamoWrite[Set[String]] {
    override def write(a: Set[String]): DynamoType = SS(a.map(StringWrite.write))
  }

  implicit def SetWriteInt: DynamoWrite[Set[Int]] = new DynamoWrite[Set[Int]] {
    override def write(a: Set[Int]): DynamoType = NS(a.map(IntWrite.write))
  }

  implicit def SetWriteShort: DynamoWrite[Set[Short]] = new DynamoWrite[Set[Short]] {
    override def write(as: Set[Short]): DynamoType = NS(as.map(ShortWrite.write))
  }

  implicit def SetWriteFloat: DynamoWrite[Set[Float]] = new DynamoWrite[Set[Float]] {
    override def write(as: Set[Float]): DynamoType = NS(as.map(FloatWrite.write))
  }

  implicit def SetWriteLong: DynamoWrite[Set[Long]] = new DynamoWrite[Set[Long]] {
    override def write(as: Set[Long]): DynamoType = NS(as.map(LongWrite.write))
  }

  implicit def SetWriteDouble: DynamoWrite[Set[Double]] = new DynamoWrite[Set[Double]] {
    override def write(as: Set[Double]): DynamoType = NS(as.map(DoubleWrite.write))
  }

  implicit def MapWrite[A](implicit ra: DynamoWrite[A]): DynamoWrite[Map[String, A]] = new DynamoWrite[Map[String, A]] {
    override def write(a: Map[String, A]): DynamoType = M(a.map(kv => (kv._1, ra.write(kv._2))).toList)
  }

}
