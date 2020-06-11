package uk.gov.hmrc.kafka.amqp.sink.helpers

import java.io.IOException
import java.util.concurrent.ConcurrentLinkedQueue

import com.rabbitmq.client.Channel
import org.apache.commons.io.FileUtils
import org.apache.qpid.server.{Broker, BrokerOptions}
import org.scalatest.{BeforeAndAfterAll, Suite}
import org.springframework.amqp.AmqpConnectException
import org.springframework.amqp.core._
import org.springframework.amqp.rabbit.connection.CachingConnectionFactory
import org.springframework.amqp.rabbit.core.{ChannelCallback, RabbitAdmin}
import org.springframework.amqp.rabbit.listener.SimpleMessageListenerContainer
import org.springframework.amqp.rabbit.listener.adapter.MessageListenerAdapter

import scala.collection.mutable
import scala.util.control.Breaks.{break, breakable}

class QpidBroker(val AMQP_Port: String, val ExchangeName: String, val QueueName: String) {
  lazy val connectionFactory = new CachingConnectionFactory(AMQP_Port.toInt)
  lazy val admin = new RabbitAdmin(connectionFactory)
  lazy val broker = new Broker()

  lazy val rabbitAdmin = new RabbitAdmin(connectionFactory)

  protected def createQpidWorkDir(): String = {
    val d = java.nio.file.Files.createTempDirectory("QpidWorkDir").toFile

    Runtime.getRuntime.addShutdownHook(new Thread() {
      override def run() {
        try
          FileUtils.deleteDirectory(d)

        catch {
          case _: IOException => // We tried!
        }
      }
    })
    d.toString
  }

  def registerMessageListener(msgs: ConcurrentLinkedQueue[(String, String)]): Unit = {
    val smlc = new SimpleMessageListenerContainer(connectionFactory)
    val listener = new Object() with MessageListener {
      override def onMessage(msg: Message): Unit = {
        msgs.add(AMQP_Port, msg.toString)
      }
    }
    val adapter = new MessageListenerAdapter(listener)

    smlc.setMessageListener(adapter)
    smlc.setQueueNames(QueueName)
    smlc.start()
  }

  def brokerStart(): Unit = {
    val brokerOptions = new BrokerOptions()
    brokerOptions.setConfigProperty("qpid.amqp_port", AMQP_Port)
    brokerOptions.setConfigProperty("qpid.broker.defaultPreferenceStoreAttributes", "{\"type\": \"Noop\"}")
    brokerOptions.setConfigProperty("qpid.pass_file", this.getClass.getResource("/passwd.properties").getFile) // "/tmp/qpid/etc/passwd.properties")
    brokerOptions.setConfigProperty("qpid.vhost", "/")
    brokerOptions.setConfigProperty("qpid.work_dir", createQpidWorkDir())
    brokerOptions.setConfigurationStoreType("Memory")
    brokerOptions.setInitialConfigurationLocation(this.getClass.getResource("/qpid-config.json").getFile) //"/tmp/qpid/etc/qpid-config.json")
    brokerOptions.setSkipLoggingConfiguration(true)
    broker.startup(brokerOptions)

    val queue = new Queue(QueueName, false)
    admin.declareQueue(queue)
    val exchange = new TopicExchange(ExchangeName)
    admin.declareExchange(exchange)
    admin.declareBinding(BindingBuilder.bind(queue).to(exchange).`with`(""))
  }

  def brokerPingDown(timeout: Int): Unit = {
    breakable {
      1 to timeout foreach {
        _ =>
          Thread.sleep(1000)
          if (!brokerPing()) break()
      }
    }
  }

  def brokerPingUp(timeout: Int): Unit = {
    breakable {
      1 to timeout foreach {
        _ =>
          Thread.sleep(1000)
          if (brokerPing()) break()
      }
    }
  }

  def brokerPing(): Boolean = {
    try {
      val rt = rabbitAdmin.getRabbitTemplate
      rt.execute(new ChannelCallback[Boolean]() {

        def doInRabbit(channel: Channel): Boolean = {
          val declareOk = channel.queueDeclarePassive(QueueName)
          declareOk.getMessageCount
          true
        }
      })
    } catch {
      case _: AmqpConnectException =>
        false
    }
  }

  def brokerStop(): Unit = {
    rabbitAdmin.deleteQueue(QueueName)
    rabbitAdmin.deleteExchange(ExchangeName)
    connectionFactory.destroy()
    broker.shutdown()
    Thread.sleep(500) // Wait for shutdown to complete
  }

  def purgeQueue(): Unit = {
    rabbitAdmin.purgeQueue(QueueName, false)
  }

}

trait QpidHelper extends BeforeAndAfterAll {
  this: Suite =>

  val AMQP_Ports: List[String]

  val ExchangeName: String
  val QueueName: String

  val brokerList: mutable.ListBuffer[QpidBroker] = new mutable.ListBuffer[QpidBroker]()

  override def beforeAll(): Unit = {
    super.beforeAll()

    AMQP_Ports.foreach {
      p =>
        val b = new QpidBroker(p, ExchangeName, QueueName)
        b.brokerStart()
        brokerList += b
    }
  }

  def registerMessageListener(msgs: ConcurrentLinkedQueue[(String, String)]): Unit = {
    brokerList.foreach {
      b =>
        b.registerMessageListener(msgs)
    }
  }

  def purgeQueue(): Unit = {
    brokerList.foreach {
      b =>
        b.purgeQueue()
    }
  }

  override def afterAll(): Unit = {
    brokerList.foreach {
      _.brokerStop()
    }
    super.afterAll()
  }
}
