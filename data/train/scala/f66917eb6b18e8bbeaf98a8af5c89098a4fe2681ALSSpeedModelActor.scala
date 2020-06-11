package recommend.speed

import org.apache.spark.SparkContext
import org.apache.spark.mllib.recommendation.Rating
import org.apache.spark.rdd.RDD
import recommend.RecomConfigure
import recommend.batch.BatchStreaming
import recommend.dataprocessing.{SampleDataProcessing, DataProcessing}
import recommend.model.ALSBatchModel
import recommend.util.BaseString._


/**
 * Created by wuyukai on 15/6/29.
 */
class ALSSpeedModelActor(sc: SparkContext,recomConf: RecomConfigure, modelManage:ALSSpeedModelManage) {


  val streamData = new BatchStreaming(sc, recomConf)
  val dataSplit = recomConf.get(Prifix + DataSplit,",")
//  val time = recomConf.getInt("kaka.speed.stream.interval", 10000)


//  println("kaka.speed.stream.interval: " + time)

  modelManage.registerCandidate()



  def run(): Unit = {

    println("StartSpeedModelStreaming")

    streamData.stream.foreachRDD{
      rdd => {
        if(!rdd.isEmpty()){


          val beginTime = System.currentTimeMillis()

          try{
            val count = rdd.count()
            if(count > 100) {

              val trainingData = ALSSpeedModelActor.dataProcessing(rdd,new SampleDataProcessing(recomConf))
              val batchModel = ALSBatchModel.trainingModel(trainingData,recomConf)
              modelManage.updateCurrStreamModel(batchModel)
              modelManage.recommendItemBatch()
              batchModel.unpersist()

            }else {

              val rawData = ALSSpeedModelActor.dataProcessing(rdd,new SampleDataProcessing(recomConf)).collect()
              modelManage.recommendItemLess(rawData.map(_.user).toIterator)

            }

          }catch{
            case e:Exception => println("Update Model Error")
          }
          val endTime = System.currentTimeMillis()
          println("Send OK, Use Time is" + (beginTime - endTime))
          rdd.unpersist()

        }
      }
    }
    streamData.start()
  }


  def stop(): Unit ={
    
    streamData.stop()
  }
}

object ALSSpeedModelActor {


  private def dataProcessing(data:RDD[(String,String)],process:DataProcessing): RDD[Rating] = {
    data.map{
      case(key, value) => {
        process.trainsformation(value)
      }
    }
  }

}
