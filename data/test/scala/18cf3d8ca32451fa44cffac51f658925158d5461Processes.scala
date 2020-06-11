package lehel.model

import java.io._
import java.util.concurrent.LinkedBlockingQueue

import better.files.File

import scala.annotation.tailrec
import scala.collection.immutable.Stream
import scala.concurrent.blocking
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.sys.process._
import scala.util.Try

object Processes {

  case class ExitCode(code: Int) extends AnyVal

  case class ProcessSpecs(workingDirectory: File, command: String, args: String*) {
    def toBuilder: ProcessBuilder =
      new java.lang.ProcessBuilder()
        .command(command +: args: _*)
        .directory(workingDirectory.toJava)
  }

  trait ProcessSystem {
    def start(): Try[RunningProcessSystem]

    def pipeTo(otherProcess: ProcessSpecs): ProcessSystem

    def pipeTo(lineProcessor: LineProcessor): ProcessSystem
  }

  trait RunningProcessSystem {
    def waitForExit(): ExitCode
  }

  def singleProcess(workingDirectory: File, process: String, args: String*): ProcessSystem =
    new SingleProcess(ProcessSpecs(workingDirectory, process, args: _*))

  private class SingleProcess(processSpecs: ProcessSpecs) extends ProcessSystem {

    private val processBuilder: ProcessBuilder = processSpecs.toBuilder

    override def start(): Try[RunningProcessSystem] = {
      Try(new SimpleRunningProcess(processBuilder.run()))
    }

    override def pipeTo(otherProcess: ProcessSpecs): ProcessSystem = {
      new CombinedProcessBuilders(processBuilder, otherProcess)
    }

    override def pipeTo(lineProcessor: LineProcessor): ProcessSystem = {
      new ProcessLineProcessor(processBuilder, lineProcessor)
    }
  }

  private class CombinedProcessBuilders(processBuilder: ProcessBuilder, processSpecs: ProcessSpecs) extends ProcessSystem {
    private val combinedProcessBuilder: ProcessBuilder = processBuilder #| processSpecs.toBuilder

    override def start(): Try[RunningProcessSystem] = {
      Try(new SimpleRunningProcess(combinedProcessBuilder.run()))
    }

    override def pipeTo(otherProcess: ProcessSpecs): ProcessSystem = {
      new CombinedProcessBuilders(combinedProcessBuilder, otherProcess)
    }

    override def pipeTo(lineProcessor: LineProcessor): ProcessSystem = {
      new ProcessLineProcessor(combinedProcessBuilder, lineProcessor)
    }
  }

  private class ProcessLineProcessor(processBuilder: ProcessBuilder, lineProcessor: LineProcessor) extends ProcessSystem {
    override def start(): Try[RunningProcessSystem] = {
      Try {
        runStreamed(System.out)
      }
    }

    private def runStreamed(out: OutputStream): StreamedRunningProcess = {
      val streamed = Streamed()
      val process = processBuilder.run(BasicIO(withIn = false, streamed.process, None))
      Future {
        blocking {
          val exitCode = process.exitValue()
          streamed.done(exitCode)
        }
      }

      new StreamedRunningProcess(process, streamed.stream(), lineProcessor, out)
    }

    override def pipeTo(otherProcess: ProcessSpecs): ProcessSystem = {
      val startSourceProcess = () => {
        val outputStream = new PipedOutputStream()
        val inputStream = new PipedInputStream(outputStream)
        val runningProcess = runStreamed(outputStream)
        (runningProcess, inputStream)
      }
      new FedProcess(startSourceProcess, otherProcess)
    }

    override def pipeTo(newLineProcessor: LineProcessor): ProcessSystem = {
      new ProcessLineProcessor(
        processBuilder,
        LineProcessor(lineProcessor.process.andThen(newLineProcessor.process))
      )
    }
  }

  private class FedProcess(createSourceProcess: () => (RunningProcessSystem, InputStream), processSpecs: ProcessSpecs) extends ProcessSystem {
    override def start(): Try[RunningProcessSystem] = {
      Try {
        val (baseProcess, inputStream) = createSourceProcess()
        val processBuilder = processSpecs.toBuilder
        val process = processBuilder.run(
          new ProcessIO(
            writeInput = { stream =>
              val buffer: Array[Byte] = new Array(1024)

              @tailrec
              def copy(): Unit = {
                val readBytes = inputStream.read(buffer)
                stream.write(buffer, 0, readBytes)
                if (readBytes > 0) {
                  copy()
                }
              }

              copy()
              stream.close()
            },
            processOutput = { stream =>
              val buffer: Array[Byte] = new Array(1024)

              @tailrec
              def copy(): Unit = {
                val readBytes = inputStream.read(buffer)
                System.out.write(buffer, 0, readBytes)
                if (readBytes > 0) {
                  copy()
                }
              }

              copy()
              stream.close()
            },
            processError = { stream =>
              val buffer: Array[Byte] = new Array(1024)

              @tailrec
              def copy(): Unit = {
                val readBytes = inputStream.read(buffer)
                System.err.write(buffer, 0, readBytes)
                if (readBytes > 0) {
                  copy()
                }
              }

              copy()
              stream.close()
            },
            daemonizeThreads = true
          ))

        new ProcessFeederRunningProcess(baseProcess, inputStream, process)
      }
    }

    override def pipeTo(otherProcess: ProcessSpecs): ProcessSystem = ???

    override def pipeTo(lineProcessor: LineProcessor): ProcessSystem = ???
  }

  private class SimpleRunningProcess(process: Process) extends RunningProcessSystem {
    override def waitForExit(): ExitCode = {
      ExitCode(process.exitValue())
    }
  }

  private class StreamedRunningProcess(val process: Process, stream: Stream[Either[ExitCode, String]], lineProcessor: LineProcessor, output: OutputStream) extends RunningProcessSystem {
    override def waitForExit(): ExitCode = {
      run(stream)
    }

    @tailrec
    private def run(current: Stream[Either[ExitCode, String]]): ExitCode = {
      current match {
        case item #:: rest =>
          lineProcessor.process(item) match {
            case Left(exitCode) =>
              process.destroy()
              exitCode
            case Right(line) =>
              output.write((line + '\n').getBytes("UTF-8"))
              run(rest)
          }
        case _ =>
          ExitCode(process.exitValue())
      }
    }
  }

  private class ProcessFeederRunningProcess(baseProcess: RunningProcessSystem, source: InputStream, process: Process) extends RunningProcessSystem {
    override def waitForExit(): ExitCode = {
      Future {
        blocking {
          baseProcess.waitForExit()
        }
      }

      ExitCode(process.exitValue())
    }
  }

  // Based on the internal Streamed class of scala.sys.process
  private final class Streamed(val process: String => Unit,
                               val done: Int => Unit,
                               val stream: () => Stream[Either[ExitCode, String]])

  private object Streamed {
    def apply(): Streamed = {
      val queue = new LinkedBlockingQueue[Either[ExitCode, String]]
      def next(): Stream[Either[ExitCode, String]] = queue.take match {
        case Left(code) => Stream.cons(Left(code), Stream.empty)
        case Right(s) => Stream.cons(Right(s), next())
      }
      new Streamed(
        (s: String) => queue.put(Right(s)),
        code => queue.put(Left(ExitCode(code))),
        () => next())
    }
  }

}