package scaredis

import scala.annotation.tailrec

trait BasicCommands {
  this: ConnectionInterface =>

  def info = {
    @tailrec
    def readOrReturn(current: String): String = {
      val line = read
      if (line.trim.isEmpty) current
      else readOrReturn(current + crlf + line)
    }

    write("INFO" + crlf)
    readOrReturn(read)
  }

  def ping = write("PING" + crlf)
  def echo(s: String) = write("ECHO %s%s".format(s, crlf))
  def bgsave = write("BGSAVE" + crlf)
  def time = write("TIME" + crlf)
  def quit = write("QUIT" + crlf)
}
