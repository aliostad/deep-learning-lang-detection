package flowlib

import ProcessUtil.{Source, Sink}

trait Folder[+T] { parent =>

  def apply[S](s0: S)(f: (S, T) => Process[S]): Process[S]

  def iterate( f: Sink[T] ): Process[Unit] =
    apply(())((_, t) => f(t))

  def map[U](g: T => U) = new Folder[U] {
    def apply[S](s0: S)(f: (S, U) => Process[S]) =
      parent.apply(s0)((s, t) => f(s, g(t)))
  }

  def flatMap[U](g: T => Folder[U]) = new Folder[U] {
    def apply[S](s0: S)(f: (S, U) => Process[S]) = {
      parent.apply(s0)((s, t) => g(t)(s)(f))
    }
  }

  def >>=[U](g: T => Folder[U]) = flatMap(g)

  def andThen[U](g: T => Process[U]) = new Folder[U] {
    def apply[S](s0: S)(f: (S, U) => Process[S]) =
      parent.apply(s0)((s, t) => g(t) >>= (f(s, _)))
  }
}

object Folder {
  import Process._
  
  def constant[T](t: T) = new Folder[T] {
    def apply[S](s0: S)(f: (S, T) => Process[S]): Process[S] = f(s0, t)
  }

  def empty = new Folder[Nothing] {
    def apply[S](s0: S)(f: (S, Nothing) => Process[S]): Process[S] = stop(s0)
  }

  def sequence[T](ts0: List[T]) = new Folder[T] {
    def apply[S](s0: S)(f: (S, T) => Process[S]): Process[S] = {
      def loop(s: S, ts: List[T]): Process[S] = ts match {
        case t :: ts1 => f(s, t) >>= (s1 => loop(s1, ts1)) 
        case Nil => stop(s)
      }
      loop(s0, ts0)
    }
  }

  def repeat[T](n0: Int)(p: Process[T]) = new Folder[T] {
    def apply[S](s0: S)(f: (S, T) => Process[S]): Process[S] = {
      def loop(s: S, n: Int): Process[S] = 
        if(n > 0) p >>= (f(s, _)) >>= (loop(_, n-1))
        else stop(s)
      loop(s0, n0)
    }
  }

  def each[T](source: Source[T]) = new Folder[T] {
    def apply[S](s0: S)(f: (S, T) => Process[S]): Process[S] = {
      def loop(s: S): Process[Nothing] = source >>= (f(s, _)) >>= loop
      loop(s0)
    }
  }

  type Streamed[+T] = Option[T]

  def stream[T](ts: Folder[T]): Sink[Streamed[T]] => Process[Unit] = { 
    sink =>
      ts.iterate( t => sink(Some(t))) >> sink(None)
  }

  def unstream[T](source: Source[Streamed[T]]) = new Folder[T] {
    def apply[S](s0: S)(f: (S, T) => Process[S]): Process[S] = {
      def loop(s: S): Process[S] = source >>= {
        case Some(t) => f(s, t) >>= loop
        case None => stop(s)
      }
      loop(s0)
    }
  }
}
