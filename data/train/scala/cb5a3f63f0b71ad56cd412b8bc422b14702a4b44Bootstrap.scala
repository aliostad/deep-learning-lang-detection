package com.tudou.core.zeus.service

import akka.actor.{Props, ActorSystem}
import akka.routing.RoundRobinRouter
import com.tudou.core.zeus.cms._
import com.tudou.core.zeus.common.hdfs.HdfsUtils
import com.tudou.core.zeus.common.dao.{SortDaoUtils, SortDao}
import com.tudou.core.zeus.common.spark.SparkUtils
import com.tudou.core.zeus.common.thread.ThreadUtils
//import com.tudou.utils.json.JsonTool
//import org.codehaus.jackson.map.ObjectMapper
import com.fasterxml.jackson.databind.ObjectMapper

import scala.collection.mutable.Map


/**
 * Created by wanganqing on 2015/3/9.
 */
object Bootstrap extends App {
  private val allTaskMap = Map[String, TaskManage]()
  private var stopMoniter = false
  private var interval = 0
  //初始化
  init()
  //启动
  start()
  //运行
  run()

  def init(): Unit = {
    //创建环境变量
    EnvUtill.init()
    //创建DB连接
    SortDaoUtils.initMysqlDataSource()
    println("db connect: " + SortDaoUtils.testConnect())
    //创建Spark
    SparkUtils.initSpark()
    //创建Hdfs连接
    HdfsUtils.init()
    //创建kafka
    //创建线程池
    ThreadUtils.init()
  }

  def start(): Unit = {
    val allTaskManager = SortService.initAllSortTasks()
    allTaskManager.foreach(t => {
      allTaskMap += (t.task.name -> t)
    })
  }

  def run(): Unit = {
    val nrOfWorkers = 10
    val actorSystem = ActorSystem("DispatchService-ActorSystem")
    val actorDispatch = actorSystem.actorOf(Props[DispatchActor].withRouter(RoundRobinRouter(nrOfWorkers)), name = "Dispatch")
    val streamTaskRegister = KafkaUtils.createConsumerStream[TaskRegister](KafkaUtils.Topic_TaskRegister)
    val streamDataRequest =  KafkaUtils.createConsumerStream[DataRequest](KafkaUtils.Topic_DataRequest)
    val streamSortRequest =  KafkaUtils.createConsumerStream[SortRequest](KafkaUtils.Topic_SortRequest)
    ThreadUtils.submit(() => {
      streamTaskRegister.foreach(stream => {
        stream.foreach(mam => {
          try {
//            actorDispatch ! new ObjectMapper().readValue(mam.message().toString, classOf[SortRequest])
            actorDispatch ! new ObjectMapper().readValue(mam.message().toString, classOf[TaskRegister])
          }
          catch {
            case  e => e.printStackTrace()
          }
          finally {}
        })
      })
    })
    ThreadUtils.submit(() => {
      streamDataRequest.foreach(stream => {
        stream.foreach(mam => {
          try {
//            actorDispatch ! new ObjectMapper().readValue(mam.message().toString, classOf[DataRequest])
            println("###get message### ->" + new ObjectMapper().readValue(mam.message().toString, classOf[DataRequest]))
            actorDispatch ! new ObjectMapper().readValue(mam.message().toString, classOf[DataRequest])
          }
          catch {
            case  e => e.printStackTrace()
          }
          finally {}
        })
      })
    })
    ThreadUtils.submit(() => {
      streamSortRequest.foreach(stream => {
        stream.foreach(mam => {
          try {
//            actorDispatch ! new ObjectMapper().readValue(mam.message().toString, classOf[SortRequest])
            actorDispatch ! new ObjectMapper().readValue(mam.message().toString, classOf[SortRequest])
          }
          catch {
            case  e => e.printStackTrace()
          }
          finally {}
        })
      })
    })

    //等待线程结束
    while (!stopMoniter && interval < 20) {
      interval = interval + 1
      println("monitor thread sleep, count:" + interval + "\t sparkContext:" + SparkUtils.sc)
      Thread.sleep(1000)
    }
  }

  def stop: Unit = {
    stopMoniter = true
  }

  def updateTaskManage(task: TaskManage): Unit = {
    allTaskMap += (task.task.name -> task)
  }

  def containsTaskManage(task: TaskManage): Boolean = {
    allTaskMap.contains(task.task.name)
  }

  def containsTaskManage(taskName: String): Boolean = {
    allTaskMap.contains(taskName)
  }

  def getTaskManage(taskName: String): TaskManage = {
    allTaskMap.getOrElse(taskName, null)
  }
}
