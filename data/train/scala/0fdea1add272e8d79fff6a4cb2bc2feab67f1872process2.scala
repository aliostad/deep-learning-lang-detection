package stream_processing

package extensible

import monad._

trait MonadCatch[F[_]] extends Monad[F] {
    def attempt[A](a: F[A]): F[Either[Throwable, A]]
    def fail[A](t: Throwable): F[A]
}

trait Process[F[_], O] {
    import Process._

    def onHalt(f: Throwable ⇒ Process[F, O]): Process[F, O] = this match {
        case Halt(e) ⇒ Try(f(e))
        case Emit(head, tail) ⇒ Emit(head, tail.onHalt(f))
        case Await(req, recv) ⇒ Await(req, recv andThen (_.onHalt(f)))
    }

    def ++(p: ⇒ Process[F, O]): Process[F, O] = {
        this.onHalt {
            case End ⇒ p
            case err ⇒ Halt(err)
        }
    }

    def flatMap[O2](f: O ⇒ Process[F, O2]): Process[F, O2] = this match {
        case Halt(err) ⇒ Halt(err)
        case Emit(o, t) ⇒ Try(f(o)) ++ t.flatMap(f)
        case Await(req, recv) ⇒ Await(req, recv andThen (_ flatMap f))
    }

    def onComplete(p: ⇒ Process[F, O]): Process[F, O] = {
        onHalt {
            case End ⇒ p.asFinalizer
            case err ⇒ p.asFinalizer ++ Halt(err)
        }
    }

    def asFinalizer: Process[F, O] = this match {
        case Emit(head, tail) ⇒ Emit(head, tail.asFinalizer)
        case Halt(e) ⇒ Halt(e)
        case Await(req, recv) ⇒ await(req) {
            case Left(Kill) ⇒ this.asFinalizer
            case x ⇒ recv(x)
        }
    }

    final def drain[O2]: Process[F, O2] = this match {
        case Halt(e) ⇒ Halt(e)
        case Emit(h, t) ⇒ t.drain
        case Await(req, recv) ⇒ Await(req, recv andThen (_.drain))
    }

    /** ex15.10 */
    def runLog(implicit mcf: MonadCatch[F]): F[IndexedSeq[O]] = {
        def go(cur: Process[F, O], acc: F[IndexedSeq[O]]): F[IndexedSeq[O]] = {
            cur match {
                case Halt(e) ⇒ e match {
                    case End ⇒ acc
                    case err ⇒ mcf.fail(err)
                }
                case Emit(head, tail) ⇒ go(tail, mcf.map(acc)(a ⇒ a :+ head))
                case Await(req, recv) ⇒ mcf.flatMap(mcf.attempt(req)) {
                    either ⇒ go(Try(recv(either)), acc)
                }
            }

        }
        go(this, mcf.unit(IndexedSeq()))
    }
}

object Process {
    case class Await[F[_], A, O](
        req: F[A], recv: Either[Throwable, A] ⇒ Process[F, O])
        extends Process[F, O]
    case class Emit[F[_], O](head: O, tail: Process[F, O]) extends Process[F, O]
    case class Halt[F[_], O](err: Throwable) extends Process[F, O]

    case object End extends Exception
    case object Kill extends Exception

    def Try[F[_], O](p: ⇒ Process[F, O]): Process[F, O] = {
        try p catch { case e: Throwable ⇒ Halt(e) }
    }

    def await[F[_], A, O](req: F[A])(
        recv: Either[Throwable, A] ⇒ Process[F, O]): Process[F, O] = {
        Await(req, recv)
    }

    /** ex15.11 */
    def eval[F[_], A](a: F[A]): Process[F, A] = {
        await(a) {
            case Left(err) ⇒ Halt(err)
            case Right(value) ⇒ Emit(value, Halt(End))
        }
    }

    def eval_[F[_], A, B](a: F[A]): Process[F, B] = {
        eval[F, A](a).drain[B]
    }

    /** ex15.12 */
    def join[F[_], O](p: Process[F, Process[F, O]]): Process[F, O] = {
        p flatMap (o ⇒ o)
    }
}