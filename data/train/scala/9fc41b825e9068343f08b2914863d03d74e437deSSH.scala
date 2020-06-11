package nu.rinu.util

import scala.sys.process.{ProcessIO, Process, BasicIO}
import java.io.InputStream
import com.typesafe.scalalogging.slf4j.Logging

class SSH(user: String, host: String, command: String) extends Logging {

  def lines(f: String => Unit) {
    val pb = processBuilder()
    wait(pb.run(BasicIO(withIn = false, f, None)))
  }

  def lines: Stream[String] = {
    val pb = processBuilder()
    pb.lines
  }

  def inputStream(f: InputStream => Unit) {
    val pb = processBuilder()
    val io = new ProcessIO(
      BasicIO.input(connect = false),
      f,
      BasicIO.getErr(None))
    wait(pb.run(io))
  }

  private def wait(process: Process) {
    try {
      process.exitValue()
    } finally {
      process.destroy()
    }
  }

  private def processBuilder() = {
    val cmd = s"ssh $host $command"
    logger.debug(cmd)
    Process(cmd)
  }

  def string(): String = {
    val pb = processBuilder()
    pb !!
  }
}


class SSHSession(user: String, host: String) {
  def this(host: String) {
    // TODO
    this("", host)
  }

  def apply(command: String): SSH = {
    new SSH(user, host, command)
  }
}

