package com.homedepot.bigbricks.ui

import code.model.Process
import com.homedepot.bbc.{ActivitiMain}
import com.homedepot.bigbricks.workflow.WorkflowWrapper
import net.liftweb.common.{Box, Full}
import net.liftweb.mapper.By

/**
  * Created by Ferosh Jacob on 11/25/16.
  */
trait DeployWorkflow extends BigBricksLogging{


  def deployProcessContent(processVars: String, definitionContent: String, fileName: String, isBBC:Box[Boolean]): Unit = {
    val message = s"$fileName deployed"
   isBBC match {
      case Full(false)=> {
        logger.info("Activiti file deploying..")
        val deployId=WorkflowWrapper.deployProcess(fileName, definitionContent)
        Process.create.processName(fileName).processVariablesName(processVars).deployementId(deployId).save()
        logAndDisplayMessage(LoggingInfo, message)
      }
      case _ => {
        deployBBC(definitionContent)

      }
    }


  }

  def createOrEdit(name: String, definitionContent: String, processVars: String, deployId: String) = {

    Process.find(By(Process.processName, name)) match {
      case Full(x) => x.deployementId(deployId).processName(name).bbc(definitionContent).processVariablesName(processVars).save()
      case _ => Process.create.deployementId(deployId).processName(name).bbc(definitionContent).processVariablesName(processVars).save()
    }

  }


  def deployBBCBatch(definitionContent: String): Unit = {
    logger.info("BBC file deploying.." +definitionContent)
    ActivitiMain.generateProcess(definitionContent) match {
      case Some(x) => {
        val name:String = (x  \\ "process" \"@name").text
        val deployId = WorkflowWrapper.deployProcess(toBPMN20File(name), x.toString())
        val message = s"$name deployed"
        val processVars =""
        createOrEdit(name,definitionContent,processVars,deployId)
      }
    }
  }
  def deployBBC(definitionContent: String): Unit = {
    logger.info("BBC file deploying..")
    ActivitiMain.generateProcess(definitionContent) match {
      case Some(x) => {
        val name:String = (x  \\ "process" \"@name").text
        val deployId = WorkflowWrapper.deployProcess(toBPMN20File(name), x.toString())
        val message = s"$name deployed"
        val processVars =ActivitiMain.variables.map(f=>f.name).mkString(",")
        createOrEdit(name,definitionContent,processVars,deployId)

        logAndDisplayMessage(LoggingInfo, message)
      }
      case None => {
        logAndDisplayMessage(LoggingError, ActivitiMain.errorMessage)
        None
      }
    }
  }

  def toBPMN20File(fileName:String) = {
    fileName+".bpmn20.xml"
  }
}
