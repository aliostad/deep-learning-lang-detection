package dao.memory

import java.util.UUID

import dao.ProcessDefinitionDao
import model.{TaskDefinitionTemplate, TaskDefinition, ProcessDefinition}

class InMemoryProcessDefinitionDao extends ProcessDefinitionDao {

  private val lock = new Object()

  private val processDefinitions = new collection.mutable.HashMap[String, ProcessDefinition]
  private val taskDefinitions = new collection.mutable.HashMap[String, TaskDefinition]
  private val taskDefinitionTemplates = new collection.mutable.HashMap[String, TaskDefinitionTemplate]

  override def loadProcessDefinitions(): Seq[ProcessDefinition] = lock.synchronized {
    processDefinitions.values.toSeq
  }

  private def taskKey(taskDefinition: TaskDefinition) = s"${taskDefinition.processId}:${taskDefinition.name}"
  private def taskTemplateKey(taskDefinitionTemplate: TaskDefinitionTemplate) = s"${taskDefinitionTemplate.processDefinitionName}:${taskDefinitionTemplate.name}"

  override def saveTaskDefinition(definition: TaskDefinition): TaskDefinition = lock.synchronized {
    taskDefinitions.put(taskKey(definition), definition)
    definition
  }

  override def loadTaskDefinitions(processId: UUID): Seq[TaskDefinition] = lock.synchronized {
    taskDefinitions.values.filter(_.processId == processId).toSeq
  }

  override def deleteTaskDefinitionTemplate(processDefinitionName: String, taskDefinitionName: String): Boolean = lock.synchronized {
    val definitionOpt = taskDefinitionTemplates.values.find { definition =>
      definition.processDefinitionName == processDefinitionName && definition.name == taskDefinitionName
    }
    definitionOpt match {
      case Some(definition) =>
        taskDefinitionTemplates.remove(taskTemplateKey(definition))
        true
      case _ => false
    }
  }

  override def saveProcessDefinition(definition: ProcessDefinition): ProcessDefinition = lock.synchronized {
    processDefinitions.put(definition.name, definition)
    definition
  }

  override def deleteProcessDefinition(processDefinitionName: String): Boolean = lock.synchronized {
    processDefinitions.remove(processDefinitionName).isDefined
  }

  override def loadProcessDefinition(processDefinitionName: String): Option[ProcessDefinition] = lock.synchronized {
    processDefinitions.get(processDefinitionName)
  }

  override def deleteAllTaskDefinitions(processId: UUID): Int = lock.synchronized {
    val toRemove = taskDefinitions.values.filter(_.processId == processId).toList
    toRemove.foreach { taskDef =>
      taskDefinitions.remove(taskKey(taskDef))
    }
    toRemove.length
  }

  override def saveTaskDefinitionTemplate(definition: TaskDefinitionTemplate): TaskDefinitionTemplate = lock.synchronized {
    taskDefinitionTemplates.put(taskTemplateKey(definition), definition)
    definition
  }

  override def loadTaskDefinitionTemplates(processDefinitionName: String): Seq[TaskDefinitionTemplate] = lock.synchronized {
    taskDefinitionTemplates.values.filter(_.processDefinitionName == processDefinitionName).toSeq
  }

  override def deleteAllTaskDefinitionTemplates(processDefinitionName: String): Int = lock.synchronized {
    val toRemove = taskDefinitionTemplates.values.filter(_.processDefinitionName == processDefinitionName).toList
    toRemove.foreach { taskDef =>
      taskDefinitionTemplates.remove(taskTemplateKey(taskDef))
    }
    toRemove.length
  }

}
