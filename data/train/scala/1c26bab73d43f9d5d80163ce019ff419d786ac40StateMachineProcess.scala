package org.o1.espresso.machine

import org.joda.time.Duration

/**
  * Created by ricardo on 12/20/16.
  */
trait StateMachineProcess {
  lazy val lastDescriptor: Option[ProcessDescriptor] = None
  val descriptor:ProcessDescriptor

  def duration :Long = new Duration(descriptor.start).getMillis

  def isMyParent(p:StateMachineProcess): Boolean =
    if(p.descriptor.processId == descriptor.parentProcessId) true else false

  def isMySibling(p:StateMachineProcess): Boolean =
    if(p.descriptor.parentProcessId == descriptor.parentProcessId) true else false

  def isMyChild(p:StateMachineProcess): Boolean =
    if(p.descriptor.parentProcessId == descriptor.processId) true else false
}

object StateMachineProcess {
  def apply: StateMachineProcess = apply(ProcessStatus.Idle)

  def apply(status: ProcessStatus.Value, id: Long = 0, parentId: Long = -1) = new StateMachineProcess {
    override lazy val lastDescriptor: Option[ProcessDescriptor] = new Some(
      ProcessDescriptor(descriptor.processId, descriptor.parentProcessId, descriptor.status, descriptor.start))
    val descriptor: ProcessDescriptor = lastDescriptor match {
      case Some(d) => ProcessDescriptor(d.processId, d.parentProcessId, status)
      case None => ProcessDescriptor(id, parentId, status)
    }
  }

  def apply(parent: StateMachineProcess) = new StateMachineProcess {
    val descriptor: ProcessDescriptor = ProcessDescriptor(
      parent.descriptor.processId + 1, parent.descriptor.processId, ProcessStatus.Idle)
  }
}
