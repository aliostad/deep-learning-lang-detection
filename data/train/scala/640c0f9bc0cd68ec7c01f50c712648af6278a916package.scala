package com.logikujo

/**
 *
 * spore / LogiDev - [Fun Functional] / Logikujo.com
 *
 * com.logikujo 24/08/13 :: 16:29 :: eof
 *
 */

import dispatch._

import scalaz._
import Scalaz._

import scala.util.{Try,Failure, Success}
import scala.concurrent.Future
import scala.concurrent.ExecutionContext.Implicits.global

package object spore
  extends SpecificationImplicits
  with MethodImplicits
  with RequestImplicits
{
  class SporeException(msg: String) extends Exception(msg)

  // TODO: Create a TypeClass to generalize both cases (and maybe more)
  //       ToDisjuntion[T] { def disjunction: String \/ T }
  // TODO: Manage Exceptions
  implicit class FutureOps[T](f: Future[T]) {
    lazy val disjunction: Future[String \/ T] = for {
      v <- f.either
    } yield v.fold(_.toString.left[T], _.right[String])
  }
  // TODO: Manage Exceptions
  implicit class TryOps[T](t: Try[T]) {
    lazy val disjunction: String \/ T = t match {
      case Success(s) => s.right[String]
      case Failure(e) => e.toString.left[T]
    }
  }
  implicit class ToFutureOps[T](t: T) {
    def future: Future[T] = Future(t)
  }
}
