package controllers

import java.util.{Date, UUID}
import javax.inject.Inject

import model.{KillProcessRequest, ProcessStatusType, TaskBackoff}
import org.joda.time.DateTime
import com.gilt.svc.sundial.v0
import com.gilt.svc.sundial.v0.models.json._
import dao.SundialDaoFactory
import play.api.libs.json.Json
import play.api.mvc._

class Processes @Inject() (daoFactory: SundialDaoFactory) extends Controller {

  def get(processDefinitionName: Option[String],
          startTime: Option[DateTime],
          endTime: Option[DateTime],
          maxRecords: Option[Int],
          validStatuses: List[v0.models.ProcessStatus]) = Action {

    val validStatusTypes = {
      if(validStatuses.isEmpty) {
        None
      } else {
        Some(validStatuses.map(ModelConverter.toInternalProcessStatusType))
      }
    }
    val result: Seq[v0.models.Process] = daoFactory.withSundialDao { implicit dao =>
      val processes = dao.processDao.findProcesses(processDefinitionName,
                                                   startTime.map(_.toDate()),
                                                   endTime.map(_.toDate()),
                                                   validStatusTypes,
                                                   maxRecords)
      processes.map(ModelConverter.toExternalProcess)
    }

    Ok(Json.toJson(result))
  }

  def getByProcessId(processId: UUID) = Action {
    val resultOpt = daoFactory.withSundialDao { implicit dao =>
      dao.processDao.loadProcess(processId).map(ModelConverter.toExternalProcess)
    }

    resultOpt match {
      case Some(result) => Ok(Json.toJson(result))
      case _ => NotFound
    }
  }

  def postRetryByProcessId(processId: UUID) = Action {
    daoFactory.withSundialDao { dao =>
      val processOpt = dao.processDao.loadProcess(processId)
      processOpt match {
        case None => NotFound
        case Some(process) =>
          if (process.status.statusType == ProcessStatusType.Running || process.status.statusType == ProcessStatusType.Failed) {
            val tasksToRetry = dao.processDao.loadTasksForProcess(processId).filter { task =>
              task.status match {
                case model.TaskStatus.Failure(_, _) => true
                case _ => false
              }
            }

            val taskDefinitions = dao.processDefinitionDao.loadTaskDefinitions(process.id)
            taskDefinitions.foreach { taskDefinition =>
              if (tasksToRetry.exists(_.taskDefinitionName == taskDefinition.name)) {
                val updatedDefinition = taskDefinition.copy(limits = taskDefinition.limits.copy(maxAttempts = taskDefinition.limits.maxAttempts + 1), backoff = TaskBackoff(0, 0))
                dao.processDefinitionDao.saveTaskDefinition(updatedDefinition)
              }
            }
            val newProcess = process.copy(status = model.ProcessStatus.Running())
            dao.processDao.saveProcess(newProcess)
            Created
          } else {
            BadRequest("Cannot retry a process that is has successfully completed")
          }
      }
    }
  }

  def postKillByProcessId(processId: UUID) = Action {
    daoFactory.withSundialDao { dao =>
      dao.triggerDao.saveKillProcessRequest(KillProcessRequest(UUID.randomUUID(), processId, new Date()))
    }

    Created
  }

}
