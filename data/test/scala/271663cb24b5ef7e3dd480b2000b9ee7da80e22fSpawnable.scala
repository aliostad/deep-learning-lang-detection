package ch.inventsoft.scalabase
package oip

import executionqueue._
import process._


/**
 * Class that is spawned as its own process. 
 */
trait Spawnable {
  private[this] val startMutex: AnyRef = new Object()
  protected[oip] def start(as: SpawnStrategy) = startMutex.synchronized {
    if (_process.isSet) throw new IllegalStateException("already started")
    val p = as.spawn {
      processName(nameOfProcess)
      body
    }
    _process.set(p)
  }
  private val _process = new scala.concurrent.SyncVar[Process]
  protected lazy val process = _process.get  

  protected def body: Unit @process

  protected def nameOfProcess = Some(toString)
  override def toString = getClass.getSimpleName
}

object Spawner {
  def start[A <: Spawnable](spawnable: A, as: SpawnStrategy): A @process = {
    spawnable.start(as)
    spawnable
  }
}  


/**
 * Implements the spawning of a Spawnable. 
 */
trait SpawnStrategy extends {
  def spawn[A](body: => A @process): Process @process
  final def apply[A](body: => A @process): Process @process = spawn(body)
}
object SpawnAsOwnProcess extends SpawnStrategy {
  override def spawn[A](body: => A @process) = {
    ch.inventsoft.scalabase.process.spawn(body)
  }
}
object SpawnAsRequiredChild extends SpawnStrategy {
  override def spawn[A](body: => A @process) = {
    spawnChild(Required)(body)
  }
}
object SpawnAsMonitoredChild extends SpawnStrategy {
  override def spawn[A](body: => A @process) = {
    spawnChild(Monitored)(body)
  }
}
object RunInCallerProcess extends SpawnStrategy {
  override def spawn[A](body: => A @process) = {
    body
    self
  }
}

object Spawn {
  def asChild(childType: ChildType)(queue: ExecutionQueue = execute) = new SpawnStrategy {
    override def spawn[A](body: => A @process) = {
      spawnChildProcess(queue)(childType)(body)
    }
  }
  def asOwnProcess(queue: ExecutionQueue = execute) = new SpawnStrategy {
    override def spawn[A](body: => A @process) = {
      spawnProcess(queue)(body)
    }
  }
}
