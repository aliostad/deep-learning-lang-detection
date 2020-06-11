package com.edofic.reactivemacros

import scala.language.implicitConversions
import reactivemongo.bson._
import handlers.BSONWriter
import language.experimental.macros
/**
 * User: andraz
 * Date: 2/21/13
 * Time: 6:11 PM
 */
trait WriteBSON[A]{
  def write(value: A): BSONValue
}

trait WriteBSONimplicits {
  implicit def useExistingBSONWriter[A](implicit writer: BSONWriter[A]) = new WriteBSON[A] {
    def write(value: A): BSONValue = writer.toBSON(value)
  }

  implicit val doubleWriter = new WriteBSON[Double] {
    def write(value: Double): BSONValue = BSONDouble(value)
  }

  implicit val stringWriter = new WriteBSON[String] {
    def write(value: String): BSONValue = BSONString(value)
  }

  implicit val booleanWriter = new WriteBSON[Boolean] {
    def write(value: Boolean): BSONValue = BSONBoolean(value)
  }

  implicit val intWriter = new WriteBSON[Int] {
    def write(value: Int): BSONValue = BSONInteger(value)
  }

  implicit val longWriter = new WriteBSON[Long] {
    def write(value: Long): BSONValue = BSONLong(value)
  }

  implicit def seqWriter[A](implicit aWriter: WriteBSON[A]) = new WriteBSON[Seq[A]] {
    def write(value: Seq[A]): BSONValue = BSONArray((value map aWriter.write): _*)
  }

  implicit val objectIDWriter = new WriteBSON[BSONObjectID] {
    def write(value: BSONObjectID): BSONValue = value
  }

  implicit def any2BSONValue[A](a: A)(implicit writer: WriteBSON[A]) = writer write a
}

object WriteBSON extends WriteBSONimplicits {
  def apply[A]: BSONWriter[A] = macro MacroImpl.write[A, Options.Default]
  def custom[A, Opts  <: Options.Default]: BSONWriter[A] = macro MacroImpl.write[A,Opts]
}
