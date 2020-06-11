package me.rexim.issuestant

import scalaz._
import scalaz.stream._
import scalaz.concurrent._
import scala.language.higherKinds

package object stream {
  implicit class ProcessWithScanl[F[_], O](process: Process[F, O]) {
    def scanl[O2](x0: O2)(f: (O2, O) => O2)
      (implicit M: Monad[F], C: Catchable[F]): Process[F, O2] =
      Process.emit(x0) ++ Process.eval(
        M.map(C.attempt(process.uncons)) {
          case -\/(_) => Process.empty
          case \/-((x1, rest)) => rest.scanl(f(x0, x1))(f)
        }).flatMap(identity) // TODO(#78): get rid of flatMap(identity)
  }
}
