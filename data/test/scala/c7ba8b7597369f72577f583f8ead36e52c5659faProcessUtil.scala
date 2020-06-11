package flowlib

object ProcessUtil {
  import Process._

  type Source[+T]       = Process[T]
  type Sink[-T]         = T => Process[Unit]

  def background[U](p0: Process[U]): Process[Process[U]] = {
    val g = Gate.observable[U]()
    (p0 >>= { u => g signal Some(u); stop(u) }) & stop(Waiting(g.take))
  }

  def join[A, B]: Process[A] => Process[B] => Process[(A,B)] = {
    pa => pb =>
      background(pa) >>= { pa1 =>
        pb >>= {  b =>
          pa1 >>= { a =>
            stop((a, b))
          }
        }
      }
  }

  def forever(p: Process[Any]): Process[Nothing] =
    p >> forever(p)

  def foreach[A](la: List[A])( p: A => Process[Any] ): Process[Unit] = {
    def loop(la: List[A]): Process[Unit] = la match {
      case a :: la1 => p(a) >> loop(la1)
      case Nil => stop(())
    }
    loop(la)
  }

  def cat[A]: Source[A] => Sink[A] => Process[Nothing] =
    source => sink => forever(source >>= sink) 

  def valve[A]: Source[Any] => Source[A] => Sink[A] => Process[Nothing] =
    control => source => sink => forever(control >> (source >>= sink))

  def sendTo[A](g: Gate[A, Any]): Sink[A] = 
    a => waitDone(g offer a)

  def takeFrom[A](g: Gate[Nothing, A]): Source[A] =
    waitFor(g.take) 

  def fanout[T]( sinks: List[Sink[T]]): Sink[T] =
    t => foreach(sinks){ sink => sink(t) }

  implicit class ProcessesOp[A](ps: List[Process[A]]) {
    def !:(name: String): List[Process[A]] = ps map (name !: _)
  } 

  def parallel[A](ps: List[Process[A]]) = ps reduce ( _ & _ )
}
