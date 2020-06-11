package services

import models.Process
import play.api.Logger

import scala.collection.mutable.ListBuffer

/**
  * Created by jclavero on 19/08/2016.
  */
object ProcessStateService {

  val listProcess: ListBuffer[Process] = ListBuffer[Process]()

  def createProcess(process: models.Process): (Boolean) = {

    val resultFilterListProcess: ListBuffer[Process] = listProcess.filter(p => process.name.equals(p.name))
    if (resultFilterListProcess.length == 0) {
      listProcess += process
      Logger.info(s"Process to add $process created OK.")
    }else{
      Logger.info(s"Process $process not created.")
    }
    (resultFilterListProcess.length == 0)
  }

  def retrieveAllProcess : ListBuffer[Process] = listProcess


}
