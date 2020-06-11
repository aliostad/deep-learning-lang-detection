package flowlib

sealed trait Process[+U] extends Process.ProcessOps[U]

object Process {

  // how to recover from an error
  type Recovery = (Process[Any], Throwable) => Process[Any]

  // a constant process
  case class Complete[U](u: U) extends Process[U]

  // one process after another
  case class Sequential[V, U]( process: Process[V], step: V => Process[U]) extends Process[U]

  // a trampoline
  case class Ready[U]( step: () => Process[U] ) extends Process[U]

  // failed state triggers error handling
  case class Failed(e: Throwable) extends Process[Nothing]

  // defined error handling
  case class Recoverable[U]( p0: Process[U], recovery: Recovery) extends Process[U]

  // states for concurrent processes
  case class Waiting[U]( respond: (U => Unit) => Unit) extends Process[U]
  case class Asynchronous[U]( step: () => Process[U] ) extends Process[U]
  case class WaitingAsync[U]( respond: (U => Unit) => Unit) extends Process[U]
  case class Parallel[U]( p0: Process[Any], p1: Process[U]) extends Process[U]
  case class Alternative[U]( p0: Process[U], p1: Process[U]) extends Process[U]

  // human readable name for the process
  case class Named[U]( p0: Process[U], name: String) extends Process[U]

  def process[U]( step: => Process[U]): Process[U] = Asynchronous(() => step)

  def waitFor[T]( respond: (T => Unit) => Unit): Process[T] = WaitingAsync(respond)

  def waitDone( respond: (=> Unit) => Unit): Process[Unit] = WaitingAsync(k => respond(k(())))

  def continue[U]( step: => Process[U]): Process[U] = Ready(() => step)

  def stop[U](u: U): Process[U] = Complete(u)

  def fail(message: String, cause: Throwable=null): Process[Nothing] =
    Failed(new RuntimeException(message, cause))

  trait ProcessOps[+U] { p0: Process[U] =>
    def map[V]( f: U => V ): Process[V] = flatMap(u => Complete(f(u)))
    def flatMap[V]( step: U => Process[V]): Process[V] = Sequential(p0, step)
    def >>=[V]( step: U => Process[V]): Process[V] = Sequential(p0, step)
    def *[V]( step: U => Process[V]): Process[V] = Sequential(p0, step)
    def >>[V]( step: => Process[V]): Process[V] = Sequential(p0, (_:U) => step)
    def &[V](p1: Process[V]): Process[V] = Parallel(p0, p1)
    def |[V >: U](p1: Process[V]): Process[V] = Alternative(p0, p1)
    def !:(name: String): Process[U] = Named(p0, name)
    def recoverWith(recovery: Recovery): Process[U] = Recoverable(p0, recovery)
    override def toString = s"Process(${extractName(this)})"
  }

  private def extractName(p: Process[Any]): String = p match {
    case Named(_, name) => name
    case Parallel(p0, p1) => extractName(p0) + " & " + extractName(p1)
    case Alternative(p0, p1) => extractName(p0) + " | " + extractName(p1)
    case Sequential(p1, _) => extractName(p1) + " >>= ..."
    case _ => "..."
  }
}
