package files.assets

import java.io.File

import files.FileCrawler.{Failure, Result, Success}

import scala.concurrent.{ExecutionContext, Future}
import scala.sys.process._


object SassCompiler {

  def compile(configDirectory: String)(implicit ec: ExecutionContext): Future[Result] = {
    Future {
      val dir = new File(configDirectory)
      val cleanProcess = Process("compass clean", dir)
      val compileProcess = Process("compass compile --output-style=compressed", dir)

      try {
        println(s"clean: ${cleanProcess!!}")
        println(s"compile: ${compileProcess!!}")

        Success
      } catch {
        case e: Exception => new Failure(e.getMessage)
      }

    }
  }

}
