import akka.actor.Actor
import scala.concurrent.duration._
import scala.concurrent.{Await, Future}

import core.messages._
import core.messages.TaskManager._

/**
 * Created by mentall on 15.03.15.
 */
class TaskManager extends Actor {
  var idToTasksMap = new scala.collection.mutable.HashMap[String, Future[Any]]

  def manageTask(task: ManageTask): Unit = {
    val id = java.util.UUID.randomUUID.toString
    idToTasksMap += ((id, task.task))
    sender ! Controller.TaskCreated(id)
  }

  def replyTaskStatus(taskStatus: TaskStatus): Unit = {
    if (idToTasksMap.contains(taskStatus.taskId))
      if (idToTasksMap(taskStatus.taskId).isCompleted)
        Await.result(idToTasksMap(taskStatus.taskId), 1 minute) match {
          case MachineStarted(vmId)                         => sender() ! WebUi.MachineStarted(vmId)
          case MachineTerminated(vmId)                      => sender() ! WebUi.MachineTerminated(vmId)
          case ActorCreationSuccess(uid, subStr, sendStr)   => sender() ! WebUi.ActorCreationSuccess(uid, subStr, sendStr)
          case ActorDeleted(uid)                            => sender() ! WebUi.ActorDeleted(uid)
          case fail: General.FAIL                           => sender() ! fail
          case msg => sender ! msg
        }
      else sender ! WebUi.TaskIncomplete
    else sender ! General.FAIL("NoSuchId")
  }

  override def receive: Receive = {
    case task: ManageTask         => manageTask(task)
    case taskStatus: TaskStatus   => replyTaskStatus(taskStatus)
  }
}
