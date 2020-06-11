import sbt._
import Keys._

import io.scalac.sbt.processrunner.{ProcessRunnerPlugin, ProcessInfo}

import java.net.Socket

import scala.Console._
import scala.sys.process.ProcessBuilder

object Build extends Build {

  /**
   * Example 1:
   * Start a process.
   * Assume that it starts immediately.
   * Die after 10 seconds.
   */
  object Sleeper extends ProcessInfo {
    override def id: String = "sleeper"
    override def processBuilder: ProcessBuilder = "sleep 10"
    override def isStarted: Boolean = true
    override def applicationName: String = "Sleeper"
  }

  /**
   * Example 2:
   * Start a process which listens on a port
   * It takes some time before port opens - let's wait for that
   */
  object Listener extends ProcessInfo {
    val port: Int = 6790
    val host: String = "127.0.0.1"
    override def id: String = "listener"
    /* Starts simple nc server  */
    override def processBuilder: ProcessBuilder = {
      println(s"Starting. Try ${BLUE}telnet $host $port$RESET in a while.")
      Thread.sleep(3000)
      s"nc -kl $host $port"
    }
    /**
     * Periodically check whether a port is open.
     * Frequency and number of checks can be set by overriding
     * startupTimeout and checkInterval methods.
     */
    override def isStarted: Boolean = {
      try {
        new Socket("127.0.0.1", port).getInputStream.close()
        true
      } catch {
        case _: Exception => false
      }
    }
    override def applicationName: String = "Listener"
  }

  import ProcessRunnerPlugin.ProcessRunner
  import ProcessRunnerPlugin.Keys.processInfoList

  lazy val testProject = Project(
    id = "test-project",
    base = file("."),
    // Add settings from a ProcessRunner plugin
    settings = ProcessRunnerPlugin.processRunnerSettings ++ Seq(
      scalaVersion := "2.10.4",
      scalacOptions := Seq("-deprecation", "-feature", "-encoding", "utf8", "-language:postfixOps"),
      organization := "io.scalac",
      // Register ProcessInfo objects
      processInfoList in ProcessRunner := Seq(Sleeper, Listener)
    )
  )

}
