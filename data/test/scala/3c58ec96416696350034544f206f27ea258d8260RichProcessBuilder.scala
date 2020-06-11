package com.logikujo.sbt

import scala.sys.process._
import scala.util.{Try, Failure, Success}
import sbt.{ProcessBuilder => _, Process => _,  _}
import scala.language.implicitConversions
import scalaz._
import scalaz.Validation.fromTryCatch
import scalaz.syntax.nel._
import scalaz.syntax.bifunctor._
import scalaz.syntax.std.boolean._

/**
 *
 * sbt-livescript / LogiDev - [Fun Functional] / Logikujo.com
 *
 * sbtlivescript 16/09/13 :: 20:14 :: eof
 *
 */

sealed trait AsProcess[T] {
  def asProcess(a: T): ProcessBuilder
  def asString(a: T): List[String]
}

sealed trait RichProcessBuilder[T] {
  val v: T
  lazy val emptyLogger = ProcessLogger(_ => (), _ => ())

  sealed trait TryWithError {
    val v: ProcessBuilder
    private val error = new StringBuilder
    private def tryCommand[R](f: => R): ValidationNel[String, R] =
      ((t: Throwable) => (error.length > 0) ?
        (error.toString.wrapNel) |
        (t.getMessage.wrapNel)) <-: fromTryCatch(f) :-> (identity[R] _)

    val logger = ProcessLogger(_ => (), (e: String) => error.append(e + "\n"))

    lazy val !! : ValidationNel[String, String] = tryCommand(v.!!(logger))
    lazy val ! : ValidationNel[String, Int] = tryCommand(v.!(logger))
  }

  object TryWithError {
    def apply(p:ProcessBuilder): TryWithError = new TryWithError { val v = p }
  }

  def ?!(implicit p: AsProcess[T]) : Option[Int] =
    Try(p.asProcess(v).!(emptyLogger)).toOption
  def ??!(implicit p: AsProcess[T]) : ValidationNel[String, Int] =
    TryWithError(p.asProcess(v)).!
  def ??!!(implicit p: AsProcess[T]) : ValidationNel[String, String] =
    TryWithError(p.asProcess(v)).!!

  // Methods to add parameters
  def +(s: String)(implicit p: AsProcess[T]): ProcessBuilder = Process(p.asString(v) :+ s)
  def ++(xs: List[String])(implicit p: AsProcess[T]): ProcessBuilder = Process(p.asString(v) ++ xs)
}

trait RichProcessBuilderImplicits {
  implicit object stringAsProcess extends AsProcess[String] {
    def asProcess(s: String) = Process(s.split(" ").toList)
    def asString(s: String) = s :: Nil
  }

  implicit def stringAsRichProcess(s: String) = new RichProcessBuilder[String] {
    val v = s
  }

  implicit object processAsProcess extends AsProcess[ProcessBuilder] {
    def asString(p: ProcessBuilder) = p.toString.drop(1).dropRight(1).split(",").toList.map(_.trim)
    def asProcess(p: ProcessBuilder) = p
  }

  implicit def processAsRichProcess(p: ProcessBuilder) = new RichProcessBuilder[ProcessBuilder] {
    val v = p
  }

  implicit object fileAsProcess extends AsProcess[File] {
    def asProcess(f: File) = Process(f.toString)
    def asString(f: File) = f.toString :: Nil
  }

  implicit def fileAsRichProcess(f: File) = new RichProcessBuilder[File] {
    val v = f
  }
}