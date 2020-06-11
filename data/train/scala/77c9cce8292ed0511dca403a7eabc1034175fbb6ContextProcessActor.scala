package spark.job.rest.server.domain.actors

import akka.actor.Actor
import com.typesafe.config.Config
import org.slf4j.LoggerFactory
import spark.job.rest.config.durations.Durations

import scala.concurrent.ExecutionContext.Implicits.global
import scala.sys.process.{Process, ProcessBuilder, ProcessLogger}

object ContextProcessActor {
  case object Terminate
}

/**
 * Actor responsible for execution of context process.
 * During pre-start it schedules execution of the process configured by passed process builder.
 * @param processBuilder process builder for running process
 * @param contextName context name corresponding to a process
 * @param config application config which specifies durations
 */
class ContextProcessActor(processBuilder: ProcessBuilder, contextName: String, val config: Config) extends Actor with Durations {
  import ContextProcessActor._

  val log = LoggerFactory.getLogger(s"$getClass::$contextName")

  class Slf4jProcessLogger extends ProcessLogger {
    def out(line: => String): Unit = log.info(line)
    def err(line: => String): Unit = log.error(line)
    def buffer[T](f: => T): T = f
  }

  val process: Process = processBuilder.run(new Slf4jProcessLogger)

  /**
   * Schedules
   */
  override def preStart(): Unit = context.system.scheduler.scheduleOnce(durations.context.waitBeforeStart) {
    // Blocks execution until process exits
    val statusCode = process.exitValue()

    // Process
    if (statusCode < 0) {
      log.error(s"Context $contextName exit with error code $statusCode.")
    } else {
      log.info(s"Context process exit with status $statusCode")
    }

    context.parent ! ContextManagerActor.ContextProcessTerminated(contextName, statusCode)
    context.system.stop(self)
  }

  def receive: Receive = {
    case Terminate =>
      log.info(s"Received Terminate message")
      context.system.scheduler.scheduleOnce(durations.context.waitBeforeTermination) {
        process.destroy()
        context.system.stop(self)
      }
  }
}
