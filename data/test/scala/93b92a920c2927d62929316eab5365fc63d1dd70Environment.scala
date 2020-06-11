package com.agecomp

import akka.actor._

abstract class Environment extends Actor {
  var processors: List[Processor] = Nil
  val scene = Scene()

  def create(agent: AgentRef) = {
    val actorRef = context.actorOf(agent.props, name = agent.id.toString)
    agent.actor = actorRef
    agent.flag = "Running"
  }

  def remove(agent: AgentRef) = {
    agent.actor ! PoisonPill
    scene.container("com.agecomp.AgentRef").remove(agent.id)
  }

  def manage = {
    val agents = scene.container("com.agecomp.AgentRef")

    for ((id, component) <- agents) {
      val agent = component.asInstanceOf[AgentRef]
      agent.flag match {
        case "Create" => create(agent)
        case "Remove" => remove(agent)
        case _ => Unit
      }
    }
  }
}
