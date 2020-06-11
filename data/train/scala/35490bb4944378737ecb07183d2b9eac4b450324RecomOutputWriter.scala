package com.useready.tracking.recommendation

import machinebalancing.domain.CloudBalance
import scala.collection.JavaConverters._
/**
 * Created by Ashu on 27-03-2015.
 */
object RecomOutputWriter {

  //create worker process map
  val workerProcessMap = MainClassRecom.workerProcessList.map(w => (w.worker.id, w)).toMap

  def writeRecommendation(solvedCloudBalance: CloudBalance) = {

    val processList = solvedCloudBalance.getProcessList().asScala

    //process to interpret output
    for (process <- processList) {
      val computer = process.getComputer

      //get new worker information
      val cLabel = computer.getId.toString
      val cList = cLabel.toList
      val newWorkId = cList(0).toString.toLong
      val newPeriodId = cList(1).toString.toInt

      //get process information
      val pLabel = process.getId.toString
      val pList = pLabel.toList
      val pwLabel = pList(0).toString + pList(1).toString
      val oldWorkId = pList(0).toString.toLong
      val oldPeriodId = pList(1).toString.toInt

      try {

        val processId = pList.slice(2, pList.size).foldLeft("")((b, a) => b.toString + a.toString)
          .replaceAll("^\"|\"$", "").toInt

        //if process is moved write it as recommendation
        if (pwLabel != cLabel) {
          val pName = workerProcessMap(oldWorkId).header(processId)
          val oldWorker = workerProcessMap(oldWorkId).worker.name
          val oldPeriod = Period(oldPeriodId)
          val newWorker = workerProcessMap(newWorkId).worker.name
          val newPeriod = Period(newPeriodId)
          println("Move process " + pName + " from  worker " + oldWorker + " in " + oldPeriod + " to " +
            newWorker + " in " + newPeriod)
        }
      } catch {
        case e: Exception =>
          println("exception=>"+e.getMessage)

      }
    }

  }
}