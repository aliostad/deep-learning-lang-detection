package me.jeffmay.neo4j.client

import scala.annotation.implicitNotFound

/**
  * Defines how to print a given type.
  */
@implicitNotFound(
  "No implicit Show[${T}] in scope. " +
  "Please define a way to print this type as a string defining a Show instance.")
trait Show[T] {

  /**
    * Convert the value into a human-readable string.
    */
  def show(value: T): String
}

object Show {

  /**
    * Creates an instance of [[Show]] using the provided function.
    */
  def show[A](f: A => String): Show[A] = new Show[A] {
    def show(a: A): String = f(a)
  }

  /**
    * Creates an instance of [[Show]] using object toString.
    */
  def fromToString[A]: Show[A] = new Show[A] {
    def show(a: A): String = a.toString
  }

  /**
    * Summon an instance to show a value with.
    */
  def apply[T](implicit show: Show[T]): Show[T] = show

  /**
    * By default all primitives are shown as expected.
    */
  implicit def showAsString[T <: AnyVal]: Show[T] = new Show[T @specialized(Specializable.Primitives)] {
    override def show(value: T): String = "" + value
  }

  /**
    * A string by any other name would look just the same.
    */
  implicit val showString: Show[String] = new Show[String] {
    override def show(value: String): String = value
  }
}
