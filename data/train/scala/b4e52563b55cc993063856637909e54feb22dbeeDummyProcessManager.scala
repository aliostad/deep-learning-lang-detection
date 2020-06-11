package com.productfoundry.akka.cqrs.process

import akka.actor.Props
import com.productfoundry.akka.PassivationConfig
import com.productfoundry.akka.cqrs._

object DummyProcessManager extends ProcessManagerCompanion[DummyProcessManager] {

  override def idResolution: EntityIdResolution[DummyProcessManager] = new ProcessIdResolution[DummyProcessManager] {
    override def processIdResolver: ProcessIdResolver = {
      case event: AggregateEvent => event.id
    }
  }

  def factory() = new ProcessManagerFactory[DummyProcessManager] {
    override def props(config: PassivationConfig): Props = {
      Props(classOf[DummyProcessManager], config)
    }
  }
}

class DummyProcessManager(val passivationConfig: PassivationConfig)
  extends SimpleProcessManager {

  override def receiveCommand: Receive = {
    case AggregateEventRecord(_, _, event) =>
      context.system.eventStream.publish(event)
  }
}
