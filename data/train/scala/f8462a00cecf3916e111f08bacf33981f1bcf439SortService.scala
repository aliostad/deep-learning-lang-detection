package com.tudou.core.zeus.service

import java.io.Serializable

import akka.actor.{Props, ActorSystem}
import akka.routing.RoundRobinRouter
import com.tudou.core.zeus.cms.EnvUtill._
import com.tudou.core.zeus.cms._
import com.tudou.core.zeus.common.dao.SortDaoUtils
import com.tudou.core.zeus.common.dao.SortDao._
import com.tudou.core.zeus.common.spark.SparkUtils
import com.tudou.core.zeus.common.thread._
import kafka.consumer.KafkaStream
import org.apache.spark.sql._

/**
 * Created by wanganqing on 2015/3/9.
 */
object SortService {
  /**
   * 初始化所有任务
   * @return
   */
  def initAllSortTasks(): List[TaskManage] = {
    //从数据库获取排序任务
    for (task <- SortDaoUtils.getAllSortTask()) yield {
      val taskManage = new TaskManage(task) //创建
      taskManage.startSortTask() //启动
      taskManage
    }
  }

  def closeSortTask(task: SortTaskRow) {}

  def deleteSortTask(task: SortTaskRow) {}

  /**
   * 注册新的任务
   * @param task
   */
  def registerSortTask(task: TaskRegister): Unit = {
    if (Bootstrap.containsTaskManage(task.taskName)) {
      updateSortTask(task) //有点变态
    } else {
      //保存
      val sortTaskId = SortDaoUtils.insertSortTask(task)
      val sortTask = SortDaoUtils.getSortTaskById(sortTaskId)
      //启动
      val taskManage = new TaskManage(sortTask) //创建
      Bootstrap.updateTaskManage(taskManage)
      taskManage.startSortTask() //启动
    }


  }

  /**
   * 更新任务
   * @param task
   */
  def updateSortTask(task: TaskRegister): Unit = {
    if (!Bootstrap.containsTaskManage(task.taskName)) {
      registerSortTask(task) //有点变态
    }
    //更新
    val sortTask = SortDaoUtils.updateSortTaskByTaskName(task.taskName, task)
    //启动
    val taskManage = new TaskManage(sortTask) //创建
    Bootstrap.updateTaskManage(taskManage)
    taskManage.startSortTask() //启动
  }

  /**
   * 请求排序作业
   * @param request
   */
  def requestSortJob(request: SortRequest) = {
    //请求spark数据
    Bootstrap.getTaskManage(request.taskName).requestSortJob(request)
  }

  /**
   * 请求数据更新
   * @param request
   */
  def startUpdateData(request: DataRequest) = {
    //请求spark数据
    Bootstrap.getTaskManage(request.taskName).updateData(request)
  }


}



