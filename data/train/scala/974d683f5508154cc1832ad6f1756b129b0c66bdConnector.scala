package kopala.transport

import kopala.js.Kopala
import java.io._
import org.mozilla.javascript.{EvaluatorException, EcmaError}
import io.Source
import scala.Left
import scala.Right
import kopala.logging.{Logger, Logging}

trait Connector extends Logger { self =>
  val kopala = new { val logger = self } with Kopala

  def log(msg: String, e: Exception): Unit = {
    val stack = new StringWriter
    e.printStackTrace(new PrintWriter(stack))
    log(msg + " " + e + "\n" + stack)
  }

  def exec(msg: String) = {
    val out = new StringWriter()
    try {
      val result = kopala(msg, out)
            log("got result (" + result.getClass + "): " + result)
      val dump = out.toString
      //      log("got dump " + dump)
      Right(result, dump)
    } catch {
      case ee: EcmaError => {
        log("oops: " + ee.getErrorMessage)
        Left(ee.getErrorMessage, out.toString)
      }
      case eve: EvaluatorException => {
        log("oops: " + eve.getMessage)
        Left((eve.getMessage, out.toString))
      }
      case e: Exception => {
        log("oops,", e)
        Left(e.getMessage, out.toString)
      }
    }
  }

  def pipe(in: Source, out: Writer): Unit = pipe(in, out, out, "")

  def pipe(in: Source, out: Writer, err: Writer, prompt: String = ">"): Unit = {
    val p = new PrintWriter(out)
    val e = new PrintWriter(err)
    def ping = {
      p.print(prompt)
      p.flush
    }

    def println(s: String) = if (!s.isEmpty) p.println(s)
    ping
    in.getLines.zipWithIndex foreach { case (line, number) =>
      exec(line) match {
        case Left((errorMsg, dump)) => {println(dump); e.println("Line " + number + ":" + errorMsg) }
        case Right((result,  dump)) => {println(dump); println(result) }
      }
      ping
    }
  }

}