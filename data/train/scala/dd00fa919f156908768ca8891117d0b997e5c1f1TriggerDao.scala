package dao

import java.util.UUID

import model.{KillProcessRequest, TaskTriggerRequest, ProcessTriggerRequest}

trait TriggerDao {
  def loadOpenProcessTriggerRequests(processDefinitionName: Option[String] = None): Seq[ProcessTriggerRequest]
  def loadOpenTaskTriggerRequests(processDefinitionName: Option[String] = None): Seq[TaskTriggerRequest]
  def saveProcessTriggerRequest(request: ProcessTriggerRequest): ProcessTriggerRequest
  def saveTaskTriggerRequest(request: TaskTriggerRequest): TaskTriggerRequest
  def loadKillProcessRequests(processId: UUID): Seq[KillProcessRequest]
  def saveKillProcessRequest(request: KillProcessRequest): KillProcessRequest
}
