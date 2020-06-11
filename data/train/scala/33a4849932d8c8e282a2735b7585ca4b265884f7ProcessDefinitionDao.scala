package dao

import java.util.UUID

import model.{TaskDefinitionTemplate, TaskDefinition, ProcessDefinition}

trait ProcessDefinitionDao {
  def saveProcessDefinition(definition: ProcessDefinition): ProcessDefinition
  def loadProcessDefinition(processDefinitionName: String): Option[ProcessDefinition]
  def loadProcessDefinitions(): Seq[ProcessDefinition]
  def deleteProcessDefinition(processDefinitionName: String): Boolean

  def saveTaskDefinition(definition: TaskDefinition): TaskDefinition
  def saveTaskDefinitionTemplate(definition: TaskDefinitionTemplate): TaskDefinitionTemplate
  def loadTaskDefinitions(processId: UUID): Seq[TaskDefinition]
  def loadTaskDefinitionTemplates(processDefinitionName: String): Seq[TaskDefinitionTemplate]
  def deleteAllTaskDefinitions(processId: UUID): Int
  def deleteAllTaskDefinitionTemplates(processDefinitionName: String): Int
  def deleteTaskDefinitionTemplate(processDefinitionName: String, taskDefinitionName: String): Boolean
}
