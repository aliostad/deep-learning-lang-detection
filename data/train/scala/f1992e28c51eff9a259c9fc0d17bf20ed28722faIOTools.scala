import java.io.PrintWriter

import scala.io.Source

/**
 * Created by chisquare on 15-9-20.
 */
class IOTools(name: String) {
  val file = new PrintWriter(name + ".out")
  val console = new PrintWriter(System.out)

  def readFile: (Int, Iterator[String]) = {
    val iter = Source.fromFile(name + ".in").getLines()
    (iter.next.toInt, iter)
  }

  def writeLine[T](caseNo: Int, content: T): Unit = {
    write(file)
    write(console)

    def write(pw: PrintWriter) =
      pw.println("Case #" + caseNo + ": " + content.toString)
      file.flush
      console.flush
  }

  def writeLine[T](content: T): Unit = {
    write(file)
    write(console)

    def write(pw: PrintWriter) =
      pw.println(content.toString)
      file.flush
      console.flush
  }

  def close = {
    console.flush
    console.close
  }
}
