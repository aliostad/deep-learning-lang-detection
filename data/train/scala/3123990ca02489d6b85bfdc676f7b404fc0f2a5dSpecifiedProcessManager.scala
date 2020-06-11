package ch.inventsoft.scalabase
package oip

import process._
import Messages._
import time._
import log.Log


/**
 * Manages a single process according to a ProcessSpec.
 * - spawns the process according to the spec at creation.
 * - allows to stop the process according to the spec (optional nice with timeout).
 * - provides feedback about the process'es termination and whether it should be restarted.
 */
trait SpecifiedProcessManager {
  /**
   * @return the specification used to spawn to process.
   */
  val specification: ProcessSpecification
  /**
   * @return the spawned child process.
   */
  val managedProcess: Process
  /**
   * Stop the process.
   * @param nice
   * @return nothing as soon as the process is fully stopped
   */
  def stop(nice: Boolean): Completion @process
  
  override def toString = "Manager for ["+specification+"]["+managedProcess+"]" 
}


/**
 * Thrown if a process manager forces its own termination in reaction to a stop-request.
 */
case class ForceTermination() extends Exception("Forces termination")
/**
 * Thrown if the child could not be spawned.
 */
case class CouldNotSpawnChild(reason: Throwable) extends Exception("Could not spawn child", reason)

trait SpecifiedProcessManagerParent {
  def processStopped(manager: SpecifiedProcessManager, requestsRestart: Boolean): Unit @process
}

object SpecifiedProcessManager {
  def startAsChild(spec: ProcessSpecification, parent: SpecifiedProcessManagerParent): SpecifiedProcessManager @process = {
    val me = self
    val process = spawnChild(Monitored) {
      val child = spawnChild(Monitored) { spec() }
      val manager = new SpecifiedProcessManagerImpl(spec, parent, self, child)
      me ! SpawnedManager(manager)
      manager.run
    }
    receive {
      case SpawnedManager(manager) =>
        manager
      case ProcessCrash(`process`, reason) => 
        throw new CouldNotSpawnChild(reason)
      case ProcessKill(`process`, _, e) => e match {
	case t: Throwable => throw new RuntimeException("process killed", t)
	case e => throw new RuntimeException("process killed: "+e)
      }
    }
  }
  
  private case class SpawnedManager(manager: SpecifiedProcessManager)
  private case class StopManager(nice: Boolean) extends MessageWithSimpleReply[Unit]
  
  private class SpecifiedProcessManagerImpl(val specification: ProcessSpecification, val parent: SpecifiedProcessManagerParent, process: Process, val managedProcess: Process) extends SpecifiedProcessManager {
    protected def run: Any @process = {
      receive {
        case Terminate => doStop(false)()
        case msg: StopManager =>
          doStop(msg.nice) {
            msg.reply(())
          }
        case end: ProcessEnd =>
          if (end.process == managedProcess) {
            val shallRestart = specification.restart.shouldRestart(end)
            parent.processStopped(this, shallRestart)
          } else {
            //ignore process ends that are not for our process
          }
      }
    }

    override def stop(nice: Boolean) = StopManager(nice) sendAndSelect process
    
    protected def doStop(nice: Boolean)(whenDone: => Unit @process) = {
      val niceTimeout = if (nice) specification.shutdownTimeout else None 
      niceTimeout match {
        case Some(timeout) =>
          managedProcess ! Terminate
          receiveWithin(timeout) {
            case end: ProcessEnd if end.process == managedProcess =>
              whenDone
              None
            case Timeout => 
              whenDone
              kill
          }
        case None =>
          whenDone
          kill
      }
    }
    protected def kill = throw ForceTermination()
  }
}
