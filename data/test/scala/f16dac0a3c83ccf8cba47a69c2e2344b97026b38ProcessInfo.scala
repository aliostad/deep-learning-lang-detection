package io.scalac.sbt.processrunner

import scala.concurrent.duration._

import scala.sys.process.ProcessBuilder

trait ProcessInfo {

  /**
   * Id of the process. Must be unique.
   */
  def id: String

  /**
   * Your process definition.
   */
  def processBuilder: ProcessBuilder

  /**
   * This method is ran to check if process has started.
   */
  def isStarted: Boolean

  /**
   * Long, more descriptive application name.
   */
  def applicationName: String = id

  /**
   * Timeout for startup of a process
   */
  def startupTimeout: FiniteDuration = 5.seconds

  /**
   * How often should we check whether process started
   */
  def checkInterval: FiniteDuration = 500.milliseconds

  /**
   * Event handlers
   */
  def beforeStart(): Unit = {}

  def afterStart(): Unit = {}

  def beforeStop(): Unit = {}

  def afterStop(): Unit = {}

  override def toString = applicationName

}
