package com.github.verlattice.client

import org.scalajs.dom.XMLHttpRequest
import org.scalajs.dom.ext.Ajax

import scala.collection.mutable
import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future
import scala.scalajs.js
import scala.scalajs.js.Dynamic
import scala.scalajs.js.Dynamic.{global => g}

object MockServer {

  def getVersion: Future[String] = {
    val url = "http://localhost:8000/version"
    val eventualRequest: Future[XMLHttpRequest] = Ajax.get(url)
    eventualRequest.map(request => {
      val json: String = request.responseText
      js.JSON.parse(json).version.toString
    })
  }

  private val actions = mutable.HashSet[Action]()
  private val plans = mutable.HashSet[Plan]()

  def getResourceTypeNames: Future[List[String]] = {
    val url = "http://localhost:8000/resources"
    val eventualRequest: Future[XMLHttpRequest] = Ajax.get(url)
    eventualRequest.map(request => {
      val json: String = request.responseText
      val resources: Dynamic = js.JSON.parse(json).resources
      resources match {
        case list: js.Array[_] => list.map(res => res.toString).toList
      }
    })
  }

  def addResourceTypeName(resourceTypeName: String): Unit = {
    val url = "http://localhost:8000/resources/" + g.encodeURI(resourceTypeName)
    Ajax.post(url)
  }

  // TODO Move to server
  def getActionNames: List[String] = actions.map(action => action.name).toList.sorted

  // TODO Move to server
  def addAction(action: Action): Unit = {
    actions += action
  }

  // TODO Move to server
  def getAction(actionName: String): Action = {
    actions.filter(existingAction => existingAction.name == actionName).head
  }

  def resourceExists(actionName: String): Future[Boolean] = {
    val namesFuture: Future[List[String]] = getResourceTypeNames
    namesFuture.map(names => names.contains(actionName))
  }

  // TODO Move to server
  def updateAction(action: Action): Unit = {
    val oldAction = actions.filter(existingAction => existingAction.name == action.name).head
    actions.remove(oldAction)
    actions += action
  }

  // TODO Move to server
  def renameAction(oldName: String, newName: String): Unit = {
    val oldAction = actions.filter(existingAction => existingAction.name == oldName).head
    actions.remove(oldAction)
    actions += oldAction.copy(name = newName)
  }

  // TODO Move to server
  def addInputToAction(actionName: String, input: ActionInput): Unit = {
    val oldAction = actions.filter(existingAction => existingAction.name == actionName).head
    actions.remove(oldAction)
    actions += oldAction.copy(inputs = input :: oldAction.inputs)
  }

  // TODO Move to server
  def addOutputToAction(actionName: String, output: ActionOutput): Unit = {
    val oldAction = actions.filter(existingAction => existingAction.name == actionName).head
    actions.remove(oldAction)
    actions += oldAction.copy(outputs = output :: oldAction.outputs)
  }

  def getPlanNames: List[String] = plans.toList.map(plan => plan.name)

  def getPlan(planName: String): Plan = {
    plans.filter(_.name == planName).head
  }

  def addPlan(plan: Plan): Unit = {
    plans += plan
  }

  def updatePlan(oldPlanName: String, plan: Plan): Unit = {
    val oldPlan = plans.filter(p => p.name == oldPlanName).head
    plans -= oldPlan
    plans += plan
  }

  def removeElementFromPlan(planName: String, elementTime: Long): Unit = {
    val plan: Plan = getPlan(planName)
    val remainingElements: List[ScheduleElement] = plan.scheduleElements.filter(element => element.time != elementTime)
    val newPlan = plan.copy(scheduleElements = remainingElements)
    updatePlan(planName, newPlan)
  }

  def computeStates(plan: Plan): Map[Long, Either[MissingResource, List[ActionOutput]]] = {
    new StateComputer(plan, actions.toSet).computeStates()
  }

  def planHasIssues(planName: String): Boolean = {
    computeStates(getPlan(planName)).map(_._2).filter(_.isLeft).nonEmpty // At least one error
  }
}

sealed case class Plan(name: String, scheduleElements: List[ScheduleElement])

sealed case class ScheduleElement(time: Long, actionToPerform: String)

sealed case class Action(name: String, inputs: List[ActionInput], outputs: List[ActionOutput])

sealed case class ActionInput(resourceType: String, quantity: Int) {
  def render: String = resourceType + " <em>x" + quantity + "</em>"
}

sealed case class ActionOutput(resourceType: String, quantity: Int) {
  def render: String = resourceType + " <em>x" + quantity + "</em>"
}

sealed case class PlanState(time: Long, outputs: List[ActionOutput])
