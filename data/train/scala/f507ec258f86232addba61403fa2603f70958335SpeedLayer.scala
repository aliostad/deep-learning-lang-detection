package recommend.speed

import org.apache.spark.{SparkContext, SparkConf}
import akka.actor.{Props, ActorSystem}

import recommend.RecomConfigure
import recommend.util.KafkaProduce

/**
 * Created by wuyukai on 15/6/29.
 */
class SpeedLayer(conf :RecomConfigure) {

  val sconf = new SparkConf()
  sconf.setAll(conf.getVariableWithKeyStart("kaka.spark").map{case(a,b) => (a.substring(a.indexOf(".") + 1),b)})
  val sc = new SparkContext(sconf)


//  val batchModelUpdata = new BatchModelUpdataActor(sc,conf,speedModelManage)
  val speedLayerSys = ActorSystem("SpeedLayer")


  val kafkaSender = speedLayerSys.actorOf(Props(new KafkaProduce[AnyRef](conf)))
  val speedModelManage = new ALSSpeedModelManage(conf,kafkaSender)
  val speedModel = new ALSSpeedModelActor(sc,conf,speedModelManage)
  speedLayerSys.actorOf(Props(new BatchModelUpdataActor(sc,conf,speedModelManage)),"BatchModelUpdate")

  /**开始运行*/
  def start(): Unit ={
    try{
      speedModel.run()
    }catch{
      case e:Exception => println("this program create an error and will be stop imminently")
        stop()
        sys.exit()
    }

  }

  /**停止运行*/
  def stop(): Unit ={
    speedLayerSys.shutdown()
    speedModel.stop()

  }




}
