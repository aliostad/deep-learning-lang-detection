package scalaio.stream

import Api.Process

package object syntax {
  implicit class ProcessSyntax[A, B](self: Process[A, B]) {
    def values: List[B] =
      Collect(self)

    def pipe[C](pf: Process[B, C]): Process[A, C] =
      Pipe(self, pf)

    def |>[C](pf: Process[B, C]): Process[A, C] =
      pipe(pf)

    def mapping[C](f: (B) => C): Process[A, C] =
      pipe(Pipe.map(f))

    def take(i: Int): Process[A, B] =
      pipe(Pipe.take(i))

    def foldLeft[S](s: S)(f: (S, B) => S): Process[A, S] =
      pipe(Pipe.fold(s)(f))

    def scanLeft[S](s: S)(f: (S, B) => S): Process[A, S] =
      pipe(Pipe.scan(s)(f))

    def head: Process[A, B] =
      pipe(Pipe.head)

    def last: Process[A, B] =
      pipe(Pipe.last)

    def filter(f: (B) => Boolean): Process[A, B] =
      pipe(Pipe.filter(f))

    def find(f: (B) => Boolean): Process[A, B] =
      pipe(Pipe.find(f))
  }
}
