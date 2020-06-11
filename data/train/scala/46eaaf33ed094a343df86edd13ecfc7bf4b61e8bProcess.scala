package fitzroy.components

import fitzroy.util.Log
import fitzroy.clocks.{Clock, EmptyClock, LamportClock, TimeStamp}
import scala.collection.mutable.ArrayBuffer


trait Process extends Steppable {
  val code = ProcessIdGUIDGenerator()
  val id: ProcessId = ProcessId(this)
  var failed = false
  var timeToRecovery: Int = 0
  val clock: Clock = EmptyClock()
  var log: Log = Log()

  def step(): Unit
  def recv(m: Message): Unit
  def fail(downtime: Int = -1): Unit = {
    // A downtime of -1 means this process will never recover under
    // normal circumstances (restart() will reset this)
    if (!failed) {
      timeToRecovery = downtime
      failed = true
    }
  }
  def restart(): Unit = {
    timeToRecovery = 0
    failed = false
  }
  def recoveryStep(): Unit =
    if (timeToRecovery > 0) {
      timeToRecovery -= 1
    }

  // For creating a total order
  def >(p: Process) = this.code > p.code
  def >=(p: Process) = this.code >= p.code
  def <(p: Process) = this.code < p.code
  def <=(p: Process) = this.code >= p.code

  def takeSnapshot(snapId: TimeStamp): Unit = {}

  // override def hashCode: Int =>
}

// You need a reference to a process to be able to
// create a ProcessId for it
class ProcessId(private val p: Process) {
  override def toString: String = p.code.toString
  override def equals(that: Any): Boolean =
    that match {
        case that: ProcessId => that.p eq p
        case _ => false
    }
  // override def hashCode: Int => p.code
}

object ProcessId {
  def apply(p: Process): ProcessId = new ProcessId(p)

  def empty: ProcessId = ProcessId(EmptyProcess)
}

object ProcessIdGUIDGenerator {
  private var nextGuid = 0

  def apply(): Int = {
    nextGuid += 1
    nextGuid
  }
}

case object EmptyProcess extends Process {
  override val code: Int = -1
  def recv(m: Message): Unit = {}
  def step(): Unit = {}

  // For creating a total order
  override def >(p: Process) = false
  override def >=(p: Process) = false
  override def <(p: Process) = true
  override def <=(p: Process) = true
}
