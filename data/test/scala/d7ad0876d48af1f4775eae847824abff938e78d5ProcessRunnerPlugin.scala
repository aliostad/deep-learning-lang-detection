package io.scalac.sbt.processrunner

import sbt._
import Keys._
import Def.Initialize
import complete.DefaultParsers._
import complete.Parser

import akka.actor.{ActorRef, Props, ActorSystem}
import akka.pattern._
import akka.util.Timeout
import akka.util.Timeout._

import com.typesafe.config.ConfigFactory

import io.scalac.sbt.processrunner.ProcessController._
import io.scalac.sbt.processrunner._

import scala.concurrent.duration.{FiniteDuration, Duration}
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.{Await, Future}
import scala.Console._

object ProcessRunnerPlugin extends Plugin {

  val ProcessRunner = config("process-runner") describedAs "Scope for ProcessRunnerPlugin"

  object Keys {
    val processInfoList = SettingKey[Seq[ProcessInfo]]("process-info-list", "Set of ProcessInfo objects")
    val akkaConfig = SettingKey[String]("akka-config", "Configuration of ActorSystem")
    val actorSystem = SettingKey[ActorSystem]("actor-system", "The ActorSystem")
    val processInfoMap = SettingKey[Map[String, ProcessData]]("process-info-map", "Map of ProcessInfo objects")
    val messageTimeout = SettingKey[FiniteDuration]("message-timeout-in", "Message timeout for actor messages")
    val start = inputKey[Option[StartInfo]]("Starts a process")
    val stop = inputKey[Option[StopInfo]]("Stops a process")
    val status = inputKey[Option[ProcessState]]("Displays status of a process")
  }

  import Keys._

  private lazy val commandParser: Initialize[Parser[String]] = Def.setting {
    SpaceClass.+ ~> StringBasic.examples(processInfoMap.value.keySet)
  }

  object ProcessData {

    def fromProcessInfo(pi: ProcessInfo, actorSystem: ActorSystem): ProcessData = {
      ProcessData(actorSystem.actorOf(Props(new ProcessController(pi))), pi)
    }

  }

  case class ProcessData(ref: ActorRef, processInfo: ProcessInfo)

  lazy val processRunnerSettings: Seq[Setting[_]] = inConfig(ProcessRunner)(
    Seq[Setting[_]](
      processInfoList := Seq(),
      akkaConfig := defaultActorSystemConfig,
      actorSystem := {
        ConfigFactory.load(ActorSystem.getClass.getClassLoader)
        val classLoader = ActorSystem.getClass.getClassLoader
        val config = ConfigFactory
          .parseString(akkaConfig.value)
          .withFallback(ConfigFactory.defaultReference(classLoader))
        ActorSystem("ProcessRunnerPluginSystem", config, classLoader)
      },
      processInfoMap := {
        processInfoList.value.foldLeft(Map[String, ProcessData]()) {
          case (acc, pi) if acc contains pi.id => throw new Exception(s"Duplicated id in process-info-list: ${pi.id}")
          case (acc, pi) => acc + (pi.id -> ProcessData.fromProcessInfo(pi, actorSystem.value))
        }
      },
      messageTimeout := Duration(1, "minute"),
      start := startProcess(commandParser.parsed, processInfoMap.value, streams.value.log)(messageTimeout.value),
      stop := stopProcess(commandParser.parsed, processInfoMap.value, streams.value.log)(messageTimeout.value),
      status := statusProcess(commandParser.parsed, processInfoMap.value, streams.value.log)(messageTimeout.value)
    )
  )

  lazy val defaultActorSystemConfig =
    """
      |akka {
      |  loglevel = "OFF"
      |  actor {
      |    debug {
      |      receive = off
      |      autoreceive = off
      |      lifecycle = off
      |    }
      |  }
      |}
    """.stripMargin

  def queryProcess[T](processId: String, processMap: Map[String, ProcessData], log: Logger)
                     (fun: ProcessData => Future[T])
                     (implicit messageTimeout: FiniteDuration): Option[T] = {
    processMap.get(processId) match {
      case None =>
        log.info(s"Application with process-id $BLUE$processId$RESET was not found")
        None
      case Some(processData) =>
        Some(Await.result(fun(processData), messageTimeout))
    }
  }

  def startProcess(processId: String, processMap: Map[String, ProcessData], log: Logger)
                   (implicit messageTimeout: FiniteDuration): Option[StartInfo] = {
    queryProcess(processId, processMap, log) { processData =>
      implicit val timeout: Timeout = messageTimeout
      (processData.ref ? Start).mapTo[StartInfo] map { startInfo =>
        startInfo match {
          case Started =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET is running")
          case StartupFailed(exitValue) =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET failed to start. Exit value was: $exitValue.")
          case StartupFailedWithTimeout =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET failed to start [Timeout]. ")
          case AlreadyStarted =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET was already started")
        }
        startInfo
      }
    }
  }

  def stopProcess(processId: String, processMap: Map[String, ProcessData], log: Logger)
                 (implicit messageTimeout: FiniteDuration): Option[StopInfo] = {
    queryProcess(processId, processMap, log) { processData =>
      implicit val timeout: Timeout = messageTimeout
      (processData.ref ? Stop).mapTo[StopInfo] map { stopInfo =>
        stopInfo match {
          case Stopped(exitCode) =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET was stopped. Exit code: $exitCode.")
          case NotStarted =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET was not started.")
        }
        stopInfo
      }
    }
  }

  def statusProcess(processId: String, processMap: Map[String, ProcessData], log: Logger)
                   (implicit messageTimeout: FiniteDuration): Option[ProcessState] = {
    queryProcess(processId, processMap, log) { processData =>
      implicit val timeout: Timeout = messageTimeout
      (processData.ref ? Status).mapTo[StateInfo] map { stateInfo =>
        stateInfo match {
          case StateInfo(Idle) =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET is idle.")
          case StateInfo(Starting) =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET is starting.")
          case StateInfo(Running) =>
            log.info(s"$BLUE${processData.processInfo.applicationName}$RESET is running.")
        }
        stateInfo.state
      }
    }
  }

}
