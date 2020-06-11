package actors

import common.JmxConnection
import models._
import util.Util
import Util._
import common.{JmxPropertyConstant, Message}
import java.util.concurrent.TimeUnit
import java.util.Properties
import jmx.JmxDomain
import models.BrokerHistoryInfo.BrokerHistoryInfo
import javax.management.openmbean.CompositeDataSupport
import javax.management.ObjectName

/**
 * Created by davihe on 15-7-9.
 */
private class BrokerExecutor() extends Job {
  def execute(ctx: JobExecutionContext) {
    val actor = ctx.getJobDetail.getJobDataMap().get("brokerActor").asInstanceOf[ActorRef]

    //TODO 是否去掉
    //每次启动的时候，不再执行truncate了
    actor ! Message.Purge
  }
}

class BrokerHistoryManager extends Actor with JmxConnection {
  private var brokerHisotryPointsTask: Cancellable = null
  private val JobKey = "brokerMonitor"
  private[this] val props = new Properties()
  props.setProperty("org.quartz.scheduler.instanceName", context.self.path.name)
  props.setProperty("org.quartz.threadPool.threadCount", "1")
  props.setProperty("org.quartz.jobStore.class", "org.quartz.simpl.RAMJobStore")
  props.setProperty("org.quartz.scheduler.skipUpdateCheck", "true")
  val scheduler = new StdSchedulerFactory(props).getScheduler

  override def preStart() {
    scheduler.start()
    schedule()
    self ! Message.FetchBrokerMonitorInfo
  }

  override def postStop() {
    scheduler.shutdown()
  }

  override def receive: Receive = {
    case Message.FetchBrokerMonitorInfo => {
      fetchBrokerMonitorInfoPoints()

      brokerHisotryPointsTask = Akka.system.scheduler.scheduleOnce(Duration.create(Settings.findByPurgeType(Settings.PurgeTypeBroker.toString).get.FetchInterval.toLong, TimeUnit.SECONDS),
        self, Message.FetchBrokerMonitorInfo)
    }
    case Message.Purge => {
      Logger.warn(" Message.Purge in BrokerMonitorManager")
      //models.BrokerHistoryInfo.truncate()
    }
    case _ => Logger.warn("BrokerHistoryManager: undesired messages received!")
  }

  private def schedule() {
    val jdm = new JobDataMap()
    jdm.put("brokerActor", self)
    val job = JobBuilder.newJob(classOf[BrokerExecutor]).withIdentity(JobKey).usingJobData(jdm).build()
    scheduler.scheduleJob(job, TriggerBuilder.newTrigger().startNow().forJob(job).withSchedule(CronScheduleBuilder.cronSchedule(Settings.findByPurgeType(Settings.PurgeTypeBroker
      .toString).get.PurgeSchedule)).build())
  }

  private def fetchBrokerMonitorInfoPoints() {
    //host、port、数据流量、流入速度、流出速度、leader 选举频率、cpu、disk io、memory，gc时间、gc次数,根据host进行jmx调用
    Logger.info("fetchBrokerMonitorInfoPoints in BrokerMonitorManager")
    val brokers = connectedZookeepers {
      (zk, zkClient) => getBrokers(zk, zkClient)
    }

    Future.sequence(brokers).map(broker => {
      broker.map(
        for (elemOfBroker <- _) {
          val host = elemOfBroker._2.get("host")
          val port = elemOfBroker._2.get("port")
          val jmx_port = elemOfBroker._2.get("jmx_port").get match {
            case jmxPort: Double => jmxPort.toInt
            case None =>
          }

          val brokerHistoryInfo: models.BrokerHistoryInfo.BrokerHistoryInfo = getBrokerHistoryInfo(elemOfBroker, host, jmx_port,
            port)
          try {
            models.BrokerHistoryInfo.updateByIsCurrentTime(brokerHistoryInfo.name, brokerHistoryInfo.host, brokerHistoryInfo.port, 1)
            models.BrokerHistoryInfo.insert(brokerHistoryInfo)
          } catch {
            case e: Exception => e.printStackTrace()
          }
        })
    })
  }

  def getBrokerHistoryInfo(elemOfBroker: (String, Map[String, Any]), host: Option[Any], jmx_port: AnyVal,
                           port: Option[Any]): models.BrokerHistoryInfo.BrokerHistoryInfo = {

    //val datetime = java.util.Calendar.getInstance().getTime()
    val datetime = new java.sql.Timestamp(System.currentTimeMillis())
    val brokerHistoryInfo = new BrokerHistoryInfo(elemOfBroker._1.toString, host.get.toString, jmx_port.toString, datetime)
    Logger.debug("name:" + elemOfBroker._1 + " ,host: " + host + ",port: " + port + ",jmx_port: " + jmx_port)

    val conn = getJmxConn(host.get, jmx_port)

    val jmxServerDomain = new JmxDomain(JmxPropertyConstant.KAFKA_SERVER, conn)
    val brokerInfos = JmxPropertyConstant.MONITOR_INDEX_KAFKA_BROKERS.map {
      m => {
        jmxServerDomain.mbean("name", m).map {
          m => m.attribute("Count").map {
            _.value
          }
        } match {
          case Some(v) => v.get
          case None => "0"
        }
      }
    }

    //"\"AllTopicsBytesInPerSec\"", "\"AllTopicsBytesOutPerSec\"", "\"AllTopicsMessagesInPerSec\""
    brokerHistoryInfo.dataFlowIn = brokerInfos(0).toString
    brokerHistoryInfo.dataFlowOut = brokerInfos(1).toString
    brokerHistoryInfo.messagesIn = brokerInfos(2).toString

    brokerHistoryInfo.leaderElectionRate = getStringVauleByAttribute(conn,
      JmxPropertyConstant.KAFKA_CONTROLLER_LEADER_ELECTION_RATE_AND_TIMEMS, JmxPropertyConstant.COUNT)

    brokerHistoryInfo.loadAverage = getStringVauleByAttribute(conn, JmxPropertyConstant.JAVA_LANG_OPERATING_SYSTEM, JmxPropertyConstant.SYSTEM_LOAD_AVERAGE)

    val heapMemoryUsage = conn.getAttribute(new ObjectName("java.lang:type=Memory"), "HeapMemoryUsage")
    val heapMemoryUsageRate = heapMemoryUsage match {
      case compositeDataSupport: CompositeDataSupport => compositeDataSupport.get("used").toString().toInt * 100 /
        compositeDataSupport.get("committed").toString().toInt + "%"
      case Nil => "-99.99%"
    }
    brokerHistoryInfo.heapUageRate = heapMemoryUsageRate

    brokerHistoryInfo.gcCount = getStringVauleByAttribute(conn,
      JmxPropertyConstant.JAVA_LANG_GARBAGE_COLLECTOR_CONCURRENTMARKSWEEP, JmxPropertyConstant.COLLECT_COUNT)
    brokerHistoryInfo.gcTime = getStringVauleByAttribute(conn,
      JmxPropertyConstant.JAVA_LANG_GARBAGE_COLLECTOR_CONCURRENTMARKSWEEP, JmxPropertyConstant.COLLECT_TIME)

    brokerHistoryInfo
  }

  private def getBrokers(zk: Zookeeper, zkClient: ZkClient): Future[Seq[(String, Map[String, Any])]] = {
    return for {
      brokerIds <- getZChildren(zkClient, "/brokers/ids/*")
      brokers <- Future.sequence(brokerIds.map(brokerId => twitterToScalaFuture(brokerId.getData())))
    } yield brokers.map(b => (zk.name, scala.util.parsing.json.JSON.parseFull(new String(b.bytes)).get.asInstanceOf[Map[String, Any]]))
  }

  class BrokerMonitor(val monitorIndex: String, val indexValue: String, val monitorUnit: String, val eventType: String)

}
