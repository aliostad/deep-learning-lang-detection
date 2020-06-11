package nmunch

import tokenizer._

import scalaz._
import scalaz.stream._
import scalaz.concurrent._


object Main extends TaskApp {
  type Result = Token

  def toCharProcess(s: String): Process[Task, Char] = Process.emitAll(s.toSeq)
  def toStringProcess(s: String): Process[Task, String] = Process.emit(s)

  def process(s: String): Process[Task, Result] = Tok.in(toCharProcess(s))

  override def run(args: ImmutableArray[String]): Task[Unit] =
    // Process all expressions given on the command line and then every line from stdin.
    (
      for {
        line <- Process.emitAll(args) append scalaz.stream.io.stdInLines
        result <- process(line)
      } yield result.toString
    ).to(scalaz.stream.io.stdOutLines).run
}
