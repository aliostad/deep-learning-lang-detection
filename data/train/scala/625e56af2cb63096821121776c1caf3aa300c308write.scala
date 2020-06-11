package io.github.andrebeat.bytes

import scala.annotation.tailrec
import shapeless.{Generic, HList, HNil, ::}

trait Write[-A] {
  def apply(bytes: Bytes, offset: Int, value: A): Int
}

object Write {
  def apply[A: Write](bytes: Bytes, offset: Int, value: A): Int =
    implicitly[Write[A]].apply(bytes, offset, value)

  implicit object ByteWrite extends Write[Byte] {
    def apply(bytes: Bytes, offset: Int, value: Byte): Int = {
      bytes.writeByte(offset, value)
      1
    }
  }

  implicit object ShortWrite extends Write[Short] {
    def apply(bytes: Bytes, offset: Int, value: Short) = {
      bytes.writeShort(offset, value)
      2
    }
  }

  implicit object CharWrite extends Write[Char] {
    def apply(bytes: Bytes, offset: Int, value: Char) = {
      bytes.writeChar(offset, value)
      2
    }
  }

  implicit object IntWrite extends Write[Int] {
    def apply(bytes: Bytes, offset: Int, value: Int) = {
      bytes.writeInt(offset, value)
      4
    }
  }

  implicit object FloatWrite extends Write[Float] {
    def apply(bytes: Bytes, offset: Int, value: Float) = {
      bytes.writeFloat(offset, value)
      4
    }
  }

  implicit object LongWrite extends Write[Long] {
    def apply(bytes: Bytes, offset: Int, value: Long) = {
      bytes.writeLong(offset, value)
      8
    }
  }

  implicit object DoubleWrite extends Write[Double] {
    def apply(bytes: Bytes, offset: Int, value: Double) = {
      bytes.writeDouble(offset, value)
      8
    }
  }

  implicit def eitherWrite[A, B](implicit writea: Write[A], writeb: Write[B]) =
    new Write[Either[A, B]] {
      def apply(bytes: Bytes, offset: Int, value: Either[A, B]) =
        value match {
          case Left(a) =>
            bytes.writeByte(offset, 0)
            1 + writea(bytes, offset + 1, a)
          case Right(b) =>
            bytes.writeByte(offset, 1)
            1 + writeb(bytes, offset + 1, b)
        }
    }

  implicit def optionWrite[A](implicit write: Write[A]) =
    new Write[Option[A]] {
      def apply(bytes: Bytes, offset: Int, value: Option[A]) =
        value match {
          case None =>
            bytes.writeByte(offset, 0)
            1
          case Some(a) =>
            bytes.writeByte(offset, 1)
            1 + write(bytes, offset + 1, a)
        }
    }

  trait HListWrite[H <: HList] extends Write[H] {
    def apply(bytes: Bytes, offset: Int, totalSize: Int, value: H): Int
  }

  implicit def hlistWrite[H, T <: HList](implicit write: Write[H], tailWrite: HListWrite[T]) =
    new HListWrite[H :: T] {
      def apply(bytes: Bytes, offset: Int, value: H :: T) = {
        val size = write(bytes, offset, value.head)
        tailWrite(bytes, offset + size, size, value.tail)
      }
      def apply(bytes: Bytes, offset: Int, totalSize: Int, value: H :: T) = {
        val size = write(bytes, offset, value.head)
        tailWrite(bytes, offset + size, totalSize + size, value.tail)
      }
    }

  implicit object HNilWrite extends HListWrite[HNil] {
    def apply(bytes: Bytes, offset: Int, value: HNil) = 0
    def apply(bytes: Bytes, offset: Int, totalSize: Int, value: HNil) = totalSize
  }

  implicit def productWrite[P <: Product, L <: HList](implicit gen: Generic.Aux[P, L], write: Write[L]) =
    new Write[P] {
      def apply(bytes: Bytes, offset: Int, value: P) = write(bytes, offset, gen.to(value))
    }

  implicit def traversableWrite[A](implicit write: Write[A]) =
    new Write[Traversable[A]] {
      private[this] val HEADER_SIZE = 2 // Short

      def apply(bytes: Bytes, offset: Int, value: Traversable[A]): Int = {
        if (value.isEmpty) { bytes.writeShort(offset, 0); HEADER_SIZE }
        else {
          val size = write(bytes, offset + HEADER_SIZE, value.head)
          apply(bytes, offset, offset + size + HEADER_SIZE, 1, value.tail)
        }
      }

      @tailrec
      private[this] def apply(bytes: Bytes, initialOffset: Int, offset: Int, length: Int, value: Traversable[A]): Int = {
        if (value.isEmpty) { bytes.writeShort(initialOffset, length.toShort); offset - initialOffset }
        else {
          val size = write(bytes, offset, value.head)
          apply(bytes, initialOffset, offset + size, length + 1, value.tail)
        }
      }
    }
}
