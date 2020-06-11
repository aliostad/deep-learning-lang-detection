package com.github.kamekoopa.scacure.utils

import scala.language.implicitConversions

trait Show[T] {
  def show(a: T): String
}

trait ShowOps[T] {
  val self: T
  val s: Show[T]

  def show: String = s.show(self)

  def print(): Unit = Console.print(show)
  def println(): Unit = Console.println(show)

  def >>> (printer: String => Unit): Unit = {
    printer(show)
  }
}

trait ToShowOps {
  implicit def toShowOps[T](a: T)(implicit e: Show[T]) = new ShowOps[T] {
    val self: T = a
    val s: Show[T] = e
  }
}
