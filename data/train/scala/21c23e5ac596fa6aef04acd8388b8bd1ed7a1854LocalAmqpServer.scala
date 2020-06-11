package com.itv.bucky

import java.io.File

import com.google.common.io.Files
import com.itv.lifecycle.Lifecycle
import org.apache.qpid.server.logging.QpidLoggerTurboFilter
import org.apache.qpid.server.store.MemoryMessageStore
import org.apache.qpid.server.{Broker, BrokerOptions}
import org.apache.qpid.util.FileUtils

case class LocalAmqpServer(amqpPort: Int = 5672,
                           httpPort: Int = 15672,
                           passwordFile: File = new File("src/it/resources/qpid-passwd"))
    extends Lifecycle[Unit] {

  override type ServiceInstance = (File, Broker)

  override def unwrap(instance: ServiceInstance): Unit = ()

  override def start(): ServiceInstance = {
    val tmpFolder     = Files.createTempDir()
    val broker        = new Broker()
    val brokerOptions = new BrokerOptions()

    brokerOptions.setConfigProperty("qpid.work_dir", tmpFolder.getAbsolutePath)
    brokerOptions.setConfigProperty("qpid.amqp_port", s"$amqpPort")
    brokerOptions.setConfigProperty("qpid.http_port", s"$httpPort")
    brokerOptions.setConfigProperty("qpid.password_path", passwordFile.getAbsolutePath)

    brokerOptions.setConfigurationStoreType(MemoryMessageStore.TYPE)

    brokerOptions.setInitialConfigurationLocation(getClass.getResource("/qpid-config.json").toExternalForm)
    broker.startup(brokerOptions)

    QpidLoggerTurboFilter.uninstallFromRootContext()
    (tmpFolder, broker)
  }

  override def shutdown(instance: ServiceInstance): Unit = {
    val (tmpFolder, broker) = instance
    broker.shutdown()
    require(FileUtils.delete(tmpFolder, true), s"Failed to delete $tmpFolder")
  }

}
