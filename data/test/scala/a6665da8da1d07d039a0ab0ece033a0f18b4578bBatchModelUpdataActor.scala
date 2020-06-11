package recommend.speed

import org.apache.spark.SparkContext
import recommend.RecomConfigure
import recommend.model.ALSBatchModel
import recommend.util.KafkaConsumer
import recommend.util.KafKaTopics._
//import scala.actors.Actor
import recommend.util.BatchUpdateMessage
import akka.actor.{ActorSystem, Actor}

/**
 * Created by wuyukai on 15/6/29.
 */

class BatchModelUpdataActor(sc:SparkContext,recomConf: RecomConfigure, modelManage:ALSSpeedModelManage) extends Actor{

  val consumer = new KafkaConsumer(recomConf)

  val modelSavePath = recomConf.getOption("kaka.batch.model.path")

  if(modelSavePath != None) {
    println("initial model Manage --> load begin last model")
    val path = recommend.util.HadoopIO.getLastModelPath(modelSavePath.get)
    println("initial model Manage --> get last model path:" + path)
    loadBatchModel(path)
    println("initial model Manage --> initial model is finished ")
  }

  consumer.run(Map(BatchModelUpdate -> 5),self)



  def receive = {

    case BatchUpdateMessage(path) => {
      println("receive batch model updata")
      loadBatchModel(path)
    }
    case _ => {
      println("receive not useful message!")
    }

  }

  def loadBatchModel(path:String): Unit = {
    if(path != null) {
      try{
        val batchModel = new ALSBatchModel()
        batchModel.loadModel(sc,path)
        modelManage.updateCurrrBatchModel(batchModel)
        println("load model successfully")
      }catch{
        case e:Exception => println("Update batch model is fail, the path is " + path )
      }
    }
  }

}


