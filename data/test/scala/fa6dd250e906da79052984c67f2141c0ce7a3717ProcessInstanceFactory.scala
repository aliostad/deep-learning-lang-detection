package org.cucina.engine.actors


import org.cucina.engine.definition.ProcessDefinition
import org.slf4j.LoggerFactory

import scala.collection.mutable.Map
import org.cucina.engine.ProcessContext
import akka.actor.{Terminated, Actor, ActorRef, Props}


/**
  * @author vlevine
  */
case class StartInstance(processContext: ProcessContext, transitionId: String = null)

case class MoveInstance(processContext: ProcessContext, transitionId: String)

class ProcessInstanceProvider {
  def props(definition: ProcessDefinition): Props = ProcessInstance.props(definition)
}

// TODO add global listeners
class ProcessInstanceFactory(processRegistry: ActorRef, processInstanceProvider: ProcessInstanceProvider = new ProcessInstanceProvider) extends Actor {
  private[this] val LOG = LoggerFactory.getLogger(getClass)
  val instances: Map[String, ActorRef] = Map[String, ActorRef]()

  def receive = {
    case e@StartInstance(pc, transitionId) => {
      LOG.info("Starting instance " + pc + " with transition=" + transitionId)
      // ProcessInstance should be a root of it own actors
      def target: ActorRef = instances.getOrElseUpdate(pc.token.processDefinition.id, context.actorOf(processInstanceProvider.props(pc.token.processDefinition)))
      context watch target
      // washing my hands of all responses
      target forward e
    }
    case e@MoveInstance(pc, transitionId) => {
      LOG.info("Existing instance " + pc + " with transition=" + transitionId)
      // ProcessInstance should be a root of it own actors
      def target: ActorRef = instances.getOrElseUpdate(pc.token.processDefinition.id, context.actorOf(processInstanceProvider.props(pc.token.processDefinition)))
      context watch target
      // washing my hands of all responses
      target forward e
    }

    case Terminated(child) =>
      // remove dead reference to re-create upon next request
      LOG.warn("ProcessInstance " + child + " had died")
      instances.retain((k, v) => v != child)

    case e@_ => LOG.debug("Not handling " + e)
  }
}

object ProcessInstanceFactory {
  def props(processRegistry: ActorRef): Props = Props(classOf[ProcessInstanceFactory], processRegistry, new ProcessInstanceProvider)

  def props(processRegistry: ActorRef, processInstanceProvider: ProcessInstanceProvider): Props = Props(classOf[ProcessInstanceFactory], processRegistry, new ProcessInstanceProvider)
}