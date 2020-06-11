package amqptest

import java.io.File
import java.net.URL

import com.google.common.io.Files
import org.apache.qpid.server.{Broker, BrokerOptions}
import org.slf4j.LoggerFactory

trait EmbeddedAMQPBroker {
  // keystore.jks password = "CHANGEME"
  private val log = LoggerFactory.getLogger("EmbeddedAMQPBroker")

  private val tmpFolder = Files.createTempDir()
  private var broker: Broker = null

  def brokerAmqpPort = 19569

  def brokerHttpPort = 9568

  val brokerHost: String = "localhost"

  private def configFileName = "/test-config.json"
  
  def amqpUri: String = {
    s"amqps://guest:password@$brokerHost:$brokerAmqpPort"
  }

  def makeHomeDir() = {
    val home: File = new File(tmpFolder, "qpidhome")
    val resource: URL = getClass.getResource("/qpidhome")
    println(s"deploying home from $resource to $home")
    ResourceCopy.copyResourcesRecursively(resource, home)
    home
  }

  def initializeBroker(): Unit = {
    broker = new Broker()
    val brokerOptions = new BrokerOptions()

    val homePath = makeHomeDir()
    val workDir = new File(tmpFolder, "work")
    println(" qpid home dir=" + homePath.getAbsolutePath)
    println(" qpid work dir=" + workDir.getAbsolutePath)
    
    System.setProperty("amqj.logging.level", "INFO")

    brokerOptions.setConfigProperty("qpid.work_dir", workDir.getAbsolutePath)

    brokerOptions.setConfigProperty("qpid.amqp_port", s"$brokerAmqpPort")
    brokerOptions.setConfigProperty("qpid.http_port", s"$brokerHttpPort")
    brokerOptions.setConfigProperty("qpid.home_dir", homePath.getPath)

    brokerOptions.setInitialConfigurationLocation(homePath.getPath + configFileName)
    broker.startup(brokerOptions)
    log.info("broker started")
  }

  def shutdownBroker() {
    broker.shutdown()
    tmpFolder.delete()
  }
}
