package ch.inventsoft.scalabase
package oip

import process._
import Messages._
import time._


/**
 * Specification of a process. Applying executes the process's body.
 */
trait ProcessSpecification extends Function0[Unit @process] {
  val id: Option[Symbol]
  def restart: ProcessSpecification.RestartSpecification
  def shutdownTimeout: Option[Duration]
  override def toString = "ProcessSpec "+id+" ["+restart+","+shutdownTimeout+"]"
}

object ProcessSpecification {
  class ProcessSpecificationBuilder1 private[ProcessSpecification](restart: RestartSpecification) {
    def apply(id: Symbol) = new ProcessSpecificationBuilder2(Some(id), restart)
    def apply() = new ProcessSpecificationBuilder2(None, restart)
    def unnamed() = this()
  }
  class ProcessSpecificationBuilder2 private[ProcessSpecification](id: Option[Symbol], restart: RestartSpecification) {
    def withShutdownTimeout(shutdownTimeout: Duration) = new ProcessSpecification3(id, restart, Some(shutdownTimeout))
    def killForShutdown = new ProcessSpecification3(id, restart, None)
  }
  class ProcessSpecification3 private[ProcessSpecification](id1: Option[Symbol], restart1: RestartSpecification, shutdownTimeout1: Option[Duration]) {
    def apply[A](processBody: => A @process) = {
      new ProcessSpecification {
        override def apply() = {
          processBody
          ()
        }
        override val id = id1
        override val restart = restart1
        override val shutdownTimeout = shutdownTimeout1
      }
    }
    def as = apply _
  }
  
  def transient = new ProcessSpecificationBuilder1(Transient)
  def permanent = new ProcessSpecificationBuilder1(Permanent)
  def temporary = new ProcessSpecificationBuilder1(Temporary)

  sealed trait RestartSpecification {
    def shouldRestart(end: ProcessEnd): Boolean
  }
  /**
   * Is only restarted if it terminates with a ProcessCrash
   */
  object Transient extends RestartSpecification {
    override def shouldRestart(end: ProcessEnd) = end match {
      case ProcessCrash(_, reason) => true
      case otherwise => false
    }
    override def toString = "transient"
  }
  /**
   * Is always restarted.
   */
  object Permanent extends RestartSpecification {
    override def shouldRestart(end: ProcessEnd) = true
    override def toString = "permanent"
  }
  /**
   * Is not restarted.
   */
  object Temporary extends RestartSpecification {
    override def shouldRestart(end: ProcessEnd) = false
    override def toString = "temporary"
  }
}
