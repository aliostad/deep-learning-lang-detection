package com.lucasian.bpm.runtime

import java.util.Map

import scala.collection.JavaConversions._

import org.ow2.bonita.facade.`def`.majorElement.ProcessDefinition.ProcessState
import org.ow2.bonita.facade.uuid.ProcessInstanceUUID
import org.ow2.bonita.facade.QueryDefinitionAPI
import org.ow2.bonita.facade.QueryRuntimeAPI
import org.ow2.bonita.facade.RuntimeAPI
import org.ow2.bonita.util.AccessorUtil
import org.springframework.stereotype.Service

import com.lucasian.bpm.BonitaAuth
import com.lucasian.bpm.BonitaConverter
import com.lucasian.bpm.ProcessEngineFactory

@Service
class BonitaRuntimeService extends RuntimeService with BonitaAuth {

  @Override
  def startProcess(processName: String): Process = {
    bonitaLogin {
      val process = getLastActiveDeployedProcess(processName)
      val processUUID = getRuntimeApi().instantiateProcess(process.getUUID())
      val processInstance = getQueryRuntimeApi().getProcessInstance(processUUID)
      BonitaConverter.convertProcessInstance(processInstance)
    }
  }

  @Override
  def startProcess(processName: String, variables: Map[String, Object]): Process = {
    bonitaLogin {
      val process = getLastActiveDeployedProcess(processName)
      val processUUID = getRuntimeApi().instantiateProcess(process.getUUID(), variables)
      val processInstance = getQueryRuntimeApi().getProcessInstance(processUUID)
      BonitaConverter.convertProcessInstance(processInstance)
    }
  }

  @Override
  def startProcess(userId: String, processName: String): Process = {
    bonitaLogin(userId) {
      val process = getLastActiveDeployedProcess(processName)
      val processUUID = getRuntimeApi().instantiateProcess(process.getUUID())
      val processInstance = getQueryRuntimeApi().getProcessInstance(processUUID)
      BonitaConverter.convertProcessInstance(processInstance)
    }
  }

  @Override
  def startProcess(userId: String, processName: String, variables: Map[String, Object]): Process = {
    bonitaLogin {
      val process = getLastActiveDeployedProcess(processName)
      val processUUID = getRuntimeApi().instantiateProcess(process.getUUID(), variables)
      val processInstance = getQueryRuntimeApi().getProcessInstance(processUUID)
      BonitaConverter.convertProcessInstance(processInstance)
    }
  }

  @Override
  def findProcess(processId: String): Process = {
    val processUUID = new ProcessInstanceUUID(processId)
    bonitaLogin {
	    val processInstance = getQueryRuntimeApi().getProcessInstance(processUUID)
	    BonitaConverter.convertProcessInstance(processInstance)
    }
  }

  @Override
  def deleteProcess(processId: String, deleteReason: String): Unit = {
	bonitaLogin {
	  val processUUID = new ProcessInstanceUUID(processId)
	  val user = ProcessEngineFactory.findCurrentUser()
	  getRuntimeApi().addComment(processUUID, deleteReason,user)
	  getRuntimeApi().deleteProcessInstance(processUUID)
	}
  }

  private def getLastActiveDeployedProcess(processId: String) = {
    val processes = collectionAsScalaIterable(getQueryDefinitionApi().getProcesses(processId))
    val lastActiveProcess = processes
      .filter(_.getState() == ProcessState.ENABLED)
      .maxBy(_.getDeployedDate())

    lastActiveProcess
  }

  private def getQueryDefinitionApi(): QueryDefinitionAPI =
    AccessorUtil.getQueryDefinitionAPI()

  private def getQueryRuntimeApi(): QueryRuntimeAPI =
    AccessorUtil.getQueryRuntimeAPI()

  private def getRuntimeApi(): RuntimeAPI =
    AccessorUtil.getRuntimeAPI()

}