/*
 * Copyright (c) 2017 NCIC, Institute of Computing Technology, Chinese Academy of Sciences
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
package org.ncic.bioinfo.sparkseq.engine

import org.apache.spark.rdd.RDD
import org.ncic.bioinfo.sparkseq.data.partition.BundlePartition
import org.ncic.bioinfo.sparkseq.processes.PartitionProcess

import scala.collection.mutable.ListBuffer

/**
  * Author: wbc
  */
object PartitionOptimizer {
  def markProcess(rawProcessList: List[Process]): Unit = {
    val processList = rawProcessList.filter(_.isInstanceOf[PartitionProcess])
    // 查找依赖关系
    val outMap = processList.map(thisProcess => {
      val dependency = processList.filter(process => process.dependsOn(thisProcess))
      (thisProcess, dependency)
    }).toMap

    val inMap = processList.map(thisProcess => {
      val dependency = processList.filter(process => thisProcess.dependsOn(process))
      (thisProcess, dependency)
    }).toMap

    val chainListBuffer = ListBuffer[ListBuffer[Process]]()
    //根据inMap和outMap查找可优化的process链
    processList.foreach(process => {
      if (process.isInstanceOf[PartitionGenerator] && outMap(process).size == 1) {
        // 可以作为链条的开头
        var processPtr = process
        var endProcess: Process = null
        var ifContinue = true
        while (ifContinue
          && outMap(processPtr).size == 1
          && outMap(processPtr).head.isInstanceOf[PartitionConsumer]
          && inMap(outMap(processPtr).head).size == 1) {
          //如果是一个partition consumer且两边是唯一的依赖
          endProcess = outMap(processPtr).head

          processPtr = endProcess
          ifContinue = (processPtr.isInstanceOf[PartitionGenerator] && outMap(processPtr).size == 1)
        }

        // 形成chain放在list里面
        if (endProcess != null) {
          val chain = ListBuffer[Process]()
          var processPtr = process
          while (processPtr != endProcess) {
            chain += processPtr
            processPtr = outMap(processPtr).head
          }
          chain += endProcess
          chainListBuffer += chain
        }
      }
    })

    // 去除冗余的chain
    val finalChainList = ListBuffer[ListBuffer[Process]]()
    var visitedProcess = Set[Process]()
    var chainList = chainListBuffer.toList
    while (!chainList.isEmpty) {
      val maxChain = chainList.maxBy(chain => chain.size)
      finalChainList += maxChain
      visitedProcess ++= maxChain
      chainList = chainList.filter(chain => !chain.exists(process => visitedProcess.contains(process)))
    }

    // 给chain中的元素赋值，让他们按照优化方式执行
    finalChainList.foreach(chain => {
      chain.foreach(process => {
        if (process != chain.head) {
          process.asInstanceOf[PartitionConsumer].setAsChainConsumer = true
          process.asInstanceOf[PartitionConsumer].parentProcess = inMap(process).head.asInstanceOf[PartitionGenerator]
        }
        if (process != chain.last) {
          process.asInstanceOf[PartitionGenerator].setAsChainGenerator = true
          process.asInstanceOf[PartitionGenerator].childProcess = outMap(process).head.asInstanceOf[PartitionConsumer]
        }
      })
    })

  }
}

trait PartitionGenerator extends PartitionConsumer {
  var setAsChainGenerator = false
  var childProcess: PartitionConsumer = null
  var resultBundleRDD: RDD[BundlePartition] = null

  def generateBundlePartition(bundle: RDD[BundlePartition]): RDD[BundlePartition]
}

trait PartitionConsumer {
  var setAsChainConsumer = false
  var parentProcess: PartitionGenerator = null

  def consumeBundlePartition(bundle: RDD[BundlePartition]): Unit
}
