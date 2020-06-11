package net.bstjohn.scalaz

import scalaz.concurrent.Task
import scalaz.stream.{Process0, Process}

object Processes {

  val p: Process0[Int] = Process(1, 2, 3)
  val t: Process[Task, Int] = Process(1, 2, 3)

  t collect {
    case 1 => "one"
    case 2 => "two"
    case 3 => "three"
  } filter { _.size > 3 } map { _.toUpperCase }

  def nums(i: Int): Process[Task, Int] = p(i) ++ nums(i + 1)

  def p(i: Int): Process[Task, Int] = Process(i)

  nums(1).take(5).runLog

  val gets: Task[String] = Task { Console.readLine() }

  def puts(ln: String): Task[Unit] = Task { println(ln) }

  val stdin = Process.eval(gets).repeat

  val pp = stdin flatMap { line =>
    val pr = puts(line)
    Process.eval(pr)
  }

  val stdOut: Process[Task, (String) => Task[Unit]] = Process constant (puts _) toSource

  val echoServer = stdin to stdOut
}
