package com.ibm.plain
package integration
package activemq

import java.io.File

import org.apache.activemq.broker.BrokerService
import org.apache.activemq.camel.component.ActiveMQComponent.activeMQComponent
import org.apache.commons.io.FileUtils.deleteDirectory

import com.ibm.plain.bootstrap.{ ExternalComponent, Singleton }
import com.ibm.plain.integration.camel.Camel

import bootstrap.{ ExternalComponent, Singleton }
import logging.Logger

/**
 *
 */
final class ActiveMQ

    extends ExternalComponent[ActiveMQ](

      activemq.isEnabled,

      "plain-integration-activemq",

      classOf[Camel])

    with Logger {

  override def start = {

    /**
     * The master holds an activemq broker.
     */
    if (isMaster) {
      if (null == broker) {
        broker = new BrokerService
        if (usePersistence) {
          val directory = new File(persistenceDirectory)
          if (purgePersistenceDirectoryOnStartup) deleteDirectory(directory)
          broker.getPersistenceAdapter.setDirectory(directory)
          broker.setPersistent(true)
        } else {
          broker.setPersistent(false)
        }
        broker.setBrokerName(name)
        broker.setUseShutdownHook(true)
        broker.setUseJmx(true)
        broker.addConnector(brokerServerUri + ":" + brokerPort)
        broker.start
        broker.waitUntilStarted
      }
    }

    /**
     * Everybody including the master is a client.
     */
    Camel.instance.context.addComponent("activemq", activeMQComponent(brokerClientUri + ":" + brokerPort))
    ActiveMQ.instance(this)
    this
  }

  override def stop = {
    ignore(ActiveMQ.resetInstance)
    ignore(Camel.instance.context.removeComponent("activemq"))
    if (isMaster) {
      if (null != broker) {
        broker.stop
        broker.waitUntilStopped
        broker = null
      }
    }
    this
  }

  final def brokerService = Option(broker)

  private[this] final var broker: BrokerService = null

}

/**
 *
 */
object ActiveMQ

  extends Singleton[ActiveMQ]
