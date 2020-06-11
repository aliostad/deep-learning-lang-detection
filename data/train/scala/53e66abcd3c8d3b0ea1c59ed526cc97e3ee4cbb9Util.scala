import java.io.{PrintStream, ByteArrayOutputStream}

object Util {

  def discardOutput[T](f: => T): T = {
    val buffer = new ByteArrayOutputStream()
    val stream = new PrintStream(buffer)
    val oldOut = System.out
    try {
      System.setOut(stream)
      f
    } finally {
      System.setOut(oldOut)
    }
  }

  def catchOutput(f: => Unit): String = {
    val buffer = new ByteArrayOutputStream()
    val stream = new PrintStream(buffer)
    val oldOut = System.out
    try {
      System.setOut(stream)
      f
      buffer.toString
    } finally {
      System.setOut(oldOut)
    }
  }

  def catchOutputLines(f: => Unit): Seq[String] = catchOutput(f).lines.toSeq

  def catchOutputLine(f: => Unit): String = catchOutputLines(f).head

  def repeat(n: Int)(f: => Unit) {
    for (i <- 1 to n) f
  }

}
