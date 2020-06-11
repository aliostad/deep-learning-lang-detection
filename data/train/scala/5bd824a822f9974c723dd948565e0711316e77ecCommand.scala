/* Copyright 2013 Advanced Media Workflow Association and European Broadcasting Union

   Licensed under the Apache License, Version 2.0 (the "License");
   you may not use this file except in compliance with the License.
   You may obtain a copy of the License at

       http://www.apache.org/licenses/LICENSE-2.0

   Unless required by applicable law or agreed to in writing, software
   distributed under the License is distributed on an "AS IS" BASIS,
   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
   See the License for the specific language governing permissions and
   limitations under the License. */

package tv.amwa.ebu.fims.rest.model

trait Command {
  val resourceID: ResourceID
  val extensionGroup: Option[scala.xml.NodeSeq]
  val extensionAttributes: Option[scala.xml.MetaData]
}

trait ManageJobRequestType extends Command {
  val jobID: ResourceID
  val jobCommand: JobCommandType
  val priority: Option[PriorityType]
  override lazy val resourceID = jobID
}

case class ManageJobRequest(
    jobID: ResourceID,
    jobCommand: JobCommandType,
    priority: Option[PriorityType] = None,
    extensionGroup: Option[scala.xml.NodeSeq] = None,
    extensionAttributes: Option[scala.xml.MetaData] = None) extends ManageJobRequestType 
    
trait ManageQueueRequestType extends Command {
  val queueID: ResourceID
  val queueCommand: QueueCommandType
  val extensionGroup: Option[scala.xml.NodeSeq]
  val extensionAttributes: Option[scala.xml.MetaData] 
  override lazy val resourceID = queueID
}

case class ManageQueueRequest(
    queueID: ResourceID,
    queueCommand: QueueCommandType,
    extensionGroup: Option[scala.xml.NodeSeq] = None,
    extensionAttributes: Option[scala.xml.MetaData] = None) extends ManageQueueRequestType
    
trait JobCommandType

object JobCommandType {
  def fromString(value: String): JobCommandType = value match {
    case "cancel" => Cancel
    case "pause" => Pause
    case "resume" => Resume
    case "restart" => Restart
    case "stop" => Stop
    case "cleanup" => CleanUp
    case "modifyPriority" => ModifyPriority
  }
}

/** Cancel the job. */
case object Cancel extends JobCommandType { override def toString = "cancel" }
/** Pause the job. It can be restarted with resume. */
case object Pause extends JobCommandType { override def toString = "pause" }
/** Resume the job from its paused state. */
case object Resume extends JobCommandType { override def toString = "resume" }
/** Restart the job from the beginning. */
case object Restart extends JobCommandType { override def toString = "restart" }
/** Stop the job. */
case object Stop extends JobCommandType { override def toString = "stop" }
/** Remove all the data associated with the job. */
case object CleanUp extends JobCommandType { override def toString = "cleanup" }
/** Modify the priority of the job. */
case object ModifyPriority extends JobCommandType { override def toString = "modifyPriority" }

trait QueueCommandType

object QueueCommandType {
  def fromString(value: String): QueueCommandType = value match {
    case "clear" => Clear
    case "stop" => QueueStop
    case "start" => Start
    case "lock" => Lock
    case "unlock" => Unlock
  }
}

/** Retrieve the current status of the queue. */ // Not necessary for REST. Add back in for SOAP.
// case object Status extends QueueCommandType { override def toString = "status" }
/** Delete all remaining jobs in the queue. */
case object Clear extends QueueCommandType { override def toString = "clear" }
/** Stop the queue. Jobs cannot then be en-queued or de-queued. */
case object QueueStop extends QueueCommandType { override def toString = "stop" }
/** Restart a stopped queue. */
case object Start extends QueueCommandType { override def toString = "start" }
/** Lock the queue. Jobs cannot be en-queued byt the are still being processed and can be deleted. */
case object Lock extends QueueCommandType { override def toString = "lock" }
/** Unlock the queue. */
case object Unlock extends QueueCommandType { override def toString = "unlock" }



