package dao.memory

import java.util.UUID

import dao.TriggerDao
import model.{KillProcessRequest, ProcessTriggerRequest, TaskTriggerRequest}

class InMemoryTriggerDao extends TriggerDao {

  private val lock = new Object()

  private val processTriggerRequests = collection.mutable.HashMap[UUID, ProcessTriggerRequest]()
  private val taskTriggerRequests = collection.mutable.HashMap[UUID, TaskTriggerRequest]()
  private val processKillRequests = collection.mutable.HashMap[UUID, KillProcessRequest]()

  override def loadOpenProcessTriggerRequests(processDefinitionNameOpt: Option[String] = None) = lock.synchronized {
    val all = processTriggerRequests.values.filter(_.startedProcessId.isEmpty).toSeq
    processDefinitionNameOpt match {
      case Some(processDefinitionName) => all.filter(_.processDefinitionName == processDefinitionName)
      case _ => all
    }
  }

  override def saveProcessTriggerRequest(request: ProcessTriggerRequest) = lock.synchronized {
    processTriggerRequests.put(request.requestId, request)
    request
  }

  override def loadOpenTaskTriggerRequests(processDefinitionNameOpt: Option[String] = None) = lock.synchronized {
    val all = taskTriggerRequests.values.filter(_.startedProcessId.isEmpty).toSeq
    processDefinitionNameOpt match {
      case Some(processDefinitionName) => all.filter(_.processDefinitionName == processDefinitionName)
      case _ => all
    }
  }

  override def saveTaskTriggerRequest(request: TaskTriggerRequest) = lock.synchronized {
    taskTriggerRequests.put(request.requestId, request)
    request
  }

  override def loadKillProcessRequests(processId: UUID) = lock.synchronized {
    processKillRequests.values.filter(_.processId == processId).toList
  }

  override def saveKillProcessRequest(request: KillProcessRequest) = lock.synchronized {
    processKillRequests.put(request.processId, request)
    request
  }
}
