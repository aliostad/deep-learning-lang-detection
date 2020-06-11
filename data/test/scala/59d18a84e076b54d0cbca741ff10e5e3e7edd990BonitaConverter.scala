package com.lucasian.bpm

import java.util.Map
import java.util.Date

import org.ow2.bonita.facade.`def`.majorElement.{ProcessDefinition => BonitaProcessDefinition}
import org.ow2.bonita.facade.runtime.InstanceState
import org.ow2.bonita.facade.runtime.ProcessInstance
import org.ow2.bonita.facade.runtime.TaskInstance
import org.springframework.stereotype.Service

import com.lucasian.bpm.management.ProcessDefinition
import com.lucasian.bpm.management.ProcessDefinitionStatus
import com.lucasian.bpm.runtime.Process
import com.lucasian.bpm.task.BonitaTaskService
import com.lucasian.bpm.task.Task

object BonitaConverter {

  def convertTask(bonitaTask: TaskInstance, bonitaTaskService: BonitaTaskService): Task = {
    new Task {
      @Override
      def getId(): String =
        bonitaTask.getUUID().getValue()

      @Override
      def getAsignee(): String =
        bonitaTask.getTaskUser()

      @Override
      def getStartedBy(): String =
        bonitaTask.getStartedBy()

      @Override
      def getName(): String =
        bonitaTask.getActivityName()

      @Override
      def getStartedDate(): Date =
        bonitaTask.getStartedDate()

      @Override
      def getDueDate(): Date =
        bonitaTask.getExpectedEndDate()

      @Override
      def delegate(userId: String): Unit =
        bonitaTaskService.delegate(getId(), userId)

    }
  }

  def convertProcessInstance(bonitaProcessInstance: ProcessInstance): Process = {
    new Process {
      @Override
      def getId(): String =
        bonitaProcessInstance.getUUID().getValue()

      @Override
      def getVariables(): Map[String, Object] =
        bonitaProcessInstance.getLastKnownVariableValues()

      def isEnded(): Boolean =
        bonitaProcessInstance.getInstanceState() == InstanceState.FINISHED

    }
  }

  def convertProcessDefinition(bonitaProcess: BonitaProcessDefinition): ProcessDefinition = {
    new ProcessDefinition {
      @Override
      def getName(): String =
        bonitaProcess.getName()

      @Override
      def getVersion(): String =
        bonitaProcess.getVersion()

      @Override
      def getStatus(): ProcessDefinitionStatus = {
        bonitaProcess.getState() match {
          case BonitaProcessDefinition.ProcessState.ENABLED =>
            ProcessDefinitionStatus.ACTIVE
          case _ =>
            ProcessDefinitionStatus.INACTIVE
        }
      }

      @Override
      def getDeployedBy(): String =
        bonitaProcess.getDeployedBy()

    }
  }

}