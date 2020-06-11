package funpep.server
package util

import scalaz.concurrent._
import scalaz.stream._

import org.http4s._
import org.http4s.dsl._


private[util] trait Functions {

  def ok[A: EntityEncoder](content: A): Process[Task, Response] =
    Process.eval(Ok(content))

  def noContent: Process[Task, Response] =
    Process.eval(NoContent())

  def notFound: Process[Task, Response] =
    Process.eval(NotFound())

  def notFound[A: EntityEncoder](content: A): Process[Task, Response] =
    Process.eval(NotFound(content))

  def badRequest: Process[Task, Response] =
    Process.eval(BadRequest())

  def badRequest[A: EntityEncoder](content: A): Process[Task, Response] =
    Process.eval(BadRequest(content))

  def methodNotAllowed: Process[Task, Response] =
    Process.eval(MethodNotAllowed())

  def serverError: Process[Task, Response] =
    Process.eval(InternalServerError())

  def serverError[A: EntityEncoder](content: A): Process[Task, Response] =
    Process.eval(InternalServerError(content))

  // FIXME: This should be explicit
  implicit def RunLastOrServerError(p: Process[Task, Response]): Task[Response] =
    p.runLastOr[Task, Response](Response(InternalServerError))

}
