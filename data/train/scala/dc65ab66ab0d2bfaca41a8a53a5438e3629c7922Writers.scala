package net.iakovlev.easycodecs.encoder

import scala.collection.generic.CanBuildFrom
import scala.language.higherKinds

trait Writers[A] {
  implicit def writeInt: PrimitivesWriter[Int, A]
  implicit def writeLong: PrimitivesWriter[Long, A]
  implicit def writeFloat: PrimitivesWriter[Float, A]
  implicit def writeDouble: PrimitivesWriter[Double, A]
  implicit def writeBigDecimal: PrimitivesWriter[BigDecimal, A]
  implicit def writeBoolean: PrimitivesWriter[Boolean, A]
  implicit def writeString: PrimitivesWriter[String, A]
  implicit def writeIterable[C[X] <: Iterable[X]](
      implicit canBuildFrom: CanBuildFrom[C[A], A, C[A]])
    : PrimitivesWriter[C[A], A]
  implicit def writeMap: PrimitivesWriter[Map[String, A], A]
}
