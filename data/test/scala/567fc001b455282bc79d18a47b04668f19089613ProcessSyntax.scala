package net.chwthewke.scala.protobuf.plugin

import scala.language.implicitConversions
import scalaz._
import scalaz.std.vector._
import scalaz.syntax.{ MonadListenOps, MonadTellOps }

trait ProcessSyntax {

  import interface._

  object Process {
    def ask: Process[CodeGeneratorRequest] = rwstM.ask

    def apply[X](x: X): Process[X] = rwstM.point(x)

    def apply[X](f: CodeGeneratorRequest => (Vector[String], X)): Process[X] = ReaderWriterState {
      (r, _) =>
        {
          f(r) match {
            case (w, x) => (w, x, ())
          }
        }
    }
  }

  implicit def ToProcessTellOps[X](p: Process[X]): MonadTellOps[ProcessW, Vector[String], X] = {
    scalaz.syntax.monadTell.ToMonadTellOps[ProcessW, X, Vector[String]](p)
  }

  implicit def ToProcessListenOps[X](p: Process[X]): MonadListenOps[ProcessW, Vector[String], X] = {
    scalaz.syntax.monadListen.ToMonadListenOps[ProcessW, X, Vector[String]](p)
  }

  implicit class ProcessTell1Ops[X](val p: Process[X]) {
    final def :+>(w: => String): Process[X] = p :++> Vector(w)

    final def :+>>(f: X => String): Process[X] = p :++>> (x => Vector(f(x)))
  }

  private implicit val rwstM =
    RWST.rwstMonad[Id.Id, CodeGeneratorRequest, Vector[String], Unit]
}

object ProcessSyntax extends ProcessSyntax

