package com.github.atais.util

import cats.Show

trait Write[A] extends Serializable {

  def write(obj: A): String

}

object Write {

  def create[A](f: A => String): Write[A] = new Write[A] {
    override def write(obj: A): String = f(obj)
  }

  // --------------------
  // implicits

  implicit def writePrimitive[A](implicit s: Show[A]): Write[A] = create[A] {
    o =>
      s.show(o)
  }

  implicit def writeOption[A](implicit s: Write[A]): Write[Option[A]] = create[Option[A]] {
    case Some(v) => s.write(v)
    case None => ""
  }
}