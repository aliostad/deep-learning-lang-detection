package task.pawn

import java.io.InputStream
import java.util.concurrent.atomic.AtomicReference

import scala.concurrent.duration._

import scalaz.concurrent.Task

package object sys {

  import scala.sys.process._

  sealed trait ProcessResult {
    def fold[A](failure: (Int, List[String]) => A, success: List[String] => A): A = this match {
      case SuccessProcess(output) => success(output)
      case FailedProcess(exitCode, output) => failure(exitCode, output)
    }
  }
  case class SuccessProcess(output: List[String]) extends ProcessResult

  case class FailedProcess(exitCode: Int, output: List[String]) extends ProcessResult

  def executeProcess(command: ProcessBuilder)(timeOut: Duration = 10.seconds): Task[ProcessResult] = for {
    out <- mutableReference
    error <- mutableReference
    process <- Task[Process](command.run(captureIO(out, error)))
    exitCode <- Task.fork(blockUntilResponse(process)).timed(timeOut).onFinish { _ =>
      Task(process.destroy())
    }
  } yield exitCode match {
    case 0 => SuccessProcess(out.get())
    case failureExitCode => FailedProcess(failureExitCode, error.get)
  }

  private val mutableReference = Task(new AtomicReference[List[String]])

  private def blockUntilResponse(process: Process): Task[Int] = Task(process.exitValue())

  private def captureIO(out: AtomicReference[List[String]], error: AtomicReference[List[String]]): ProcessIO = {
    def redirectInputStream(out: AtomicReference[List[String]], stdout: InputStream): Unit = {
      val value = scala.io.Source.fromInputStream(stdout).getLines().toList
      out.set(value)
      stdout.close()
    }
    new ProcessIO(_ => (),
      stdout => {
        redirectInputStream(out, stdout)
      },
      stdErr => redirectInputStream(error, stdErr)
    )
  }
}