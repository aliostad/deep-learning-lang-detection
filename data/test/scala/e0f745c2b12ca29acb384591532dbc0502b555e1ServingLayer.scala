package recommend.serving

import akka.actor.ActorSystem
import com.typesafe.config.ConfigFactory
import org.apache.spark.{SparkContext, SparkConf}
import recommend.RecomConfigure
import recommend.serving.cache.RecommendUserListCache


/**
 * Created by wuyukai on 15/6/29.
 */
class ServingLayer(conf:RecomConfigure) {

//  val sconf = new SparkConf()
//  sconf.setAll(conf.getVariableWithKeyStart("kaka.spark").map{case(a,b) => (a.substring(a.indexOf(".") + 1),b)})
//  val sc = new SparkContext(sconf)

//  val modelManage = new ServingModelManage(sc, conf)

  val cache = new RecommendUserListCache

  val cconf = ConfigFactory.load("spray.conf")

  val servingLayerSys = ActorSystem("ServingLayer", cconf)

  val httpBoot = new BootServing(conf,servingLayerSys)

//  val updateActor = new UpdateModelManage(conf,modelManage,servingLayerSys)



//  val test = new TestRecommendActor(conf,modelManage,cache)

  def start(): Unit = {
    try{
      httpBoot.createHttpServing(cache)
    }catch {
      case e:Exception => println("this program create an error and will be stop")
        stop()
        sys.exit()
    }

  }

  def stop(): Unit ={
    servingLayerSys.shutdown()
  }
}
