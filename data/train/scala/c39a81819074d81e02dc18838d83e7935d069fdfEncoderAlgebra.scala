package io.aerospike4s.encoder

import com.aerospike.client.Value

import cats.Cartesian
import cats.functor.Contravariant

trait EncoderAlgebra[F[_]] extends Contravariant[F] with Cartesian[F] {
  def field[A](field: String)(implicit next: Encoder[A]): F[A]

  def opt[A](next: Encoder[A]): F[Option[A]]

  def writeString: F[String]

  def writeLong: F[Long]

  def writeNull: F[Unit]

  def writeRawValue: F[Value]

  def writeValues[A](implicit next: Encoder[A]): F[Traversable[A]]

  def writeFields[A](implicit next: Encoder[A]): F[Map[String, A]]
}
