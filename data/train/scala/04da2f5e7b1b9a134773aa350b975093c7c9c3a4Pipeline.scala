package org.ncic.bioinfo.sparkseq.engine

import org.apache.spark.SparkContext
import org.ncic.bioinfo.sparkseq.const.{BinTools, ResourceKeys}
import org.ncic.bioinfo.sparkseq.data.common.RefContigInfo
import org.ncic.bioinfo.sparkseq.exceptions.{PipelineException, ResourceException}
import org.ncic.bioinfo.sparkseq.resource.{Resource, ResourcePool}
import org.ncic.bioinfo.sparkseq.tools.LOG

import scala.collection.mutable
import scala.collection.mutable.ListBuffer

/**
  * Author: wbc
  */
object Pipeline {

  def apply(name: String, sc: SparkContext): Pipeline = {
    val pipeline = new Pipeline(name, sc)
    pipeline
  }
}

class Pipeline(val name: String, sc: SparkContext) extends Runnable {

  val doOptimize = BinTools.processOptimize

  private val log = LOG(Pipeline.getClass.getName)

  private val resourcePool: ResourcePool = ResourcePool()
  private val processList: ListBuffer[Process] = ListBuffer()

  private def init(): Unit = {
    // TODO
  }

  /**
    * 生成process的执行列表
    *
    * @return
    */
  private def generateRunnableSequence(): List[Process] = {
    val undone: mutable.HashSet[Process] = mutable.HashSet()
    val done: ListBuffer[Process] = ListBuffer()

    // 初始化，将所有Process放入undone
    undone ++= processList
    // 拷贝一份临时资源池，用于生成执行顺序时的判断。
    val resourcePoolTmp: ResourcePool = resourcePool.copy()

    // 循环遍历未完成的process列表，直到所有列表都被移入已完成列表中
    while (undone.nonEmpty) {
      val processToBeDone: ListBuffer[Process] = ListBuffer()
      //遍历未完成process
      undone.foreach(process => {
        //如果有process的输入资源全都ready，则加入到待执行列表
        if (!process.inputResources.exists(
          resource => !resourcePoolTmp.containsResource(resource))) {
          processToBeDone += process
        }
      })
      //处理待执行列表
      if (processToBeDone.isEmpty) {
        throw new PipelineException("Can't generate execute topology graph for pipeline " + name)
      }
      processToBeDone.foreach(process => {
        undone.remove(process)
        done += process
        process.outputResources.foreach(
          resource => resourcePoolTmp.addResource(resource))
      })
    }

    done.toList
  }

  def run(): Unit = {
    if (done) {
      return
    }

    init()
    if (doOptimize) {
      PartitionOptimizer.markProcess(processList.toList)
    }

    //按照依赖顺序生成执行顺序
    val processInSequence: List[Runnable] = generateRunnableSequence()

    // 按照顺序执行
    processInSequence.foreach(_.run())

    done = true
  }

  def addResource(resource: Resource): Unit = {
    resourcePool.addResource(resource)
  }

  def addProcess(process: Process): Unit = {
    if (process.done) {
      throw new PipelineException("Can't add a done process into pipeline")
    }
    if (process.getResourcePool() != null && process.getResourcePool() != resourcePool) {
      throw new PipelineException("This process may already been added into another pipeline")
    }
    process.setResourcePool(resourcePool)
    process.setSparkContext(sc)
    process.setPipeline(this)
    processList += process

    process.inputResources.filter(_.isSet).foreach(resourcePool.addResource(_))
  }

  def getResource(key: String): Resource = {
    val opt = resourcePool.getResourceByKey(key)
    if (opt.isEmpty) {
      throw new ResourceException("Resource of key '" + key + "' is not defined in process '" + name + "'")
    }
    opt.get
  }

}
