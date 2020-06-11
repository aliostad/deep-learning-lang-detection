package recommend.serving

/**
 * Created by wuyukai on 15/6/29.
 */

import akka.actor.{ActorLogging, Props, Actor, ActorSystem}
import recommend.RecomConfigure
import recommend.util.{KafkaConsumer, KafKaTopics, SpeedUpdateMessage, BatchUpdateMessage}
import scala.collection.mutable
import scala.concurrent.Future


class UpdateModelManage(conf:RecomConfigure,modelManage: ServingModelManage, sls: ActorSystem) {

  val consumer = new KafkaConsumer(conf)

  val topicMap = mutable.HashMap[String,Int]()
  topicMap(KafKaTopics.BatchModelUpdate) = 1
  topicMap(KafKaTopics.SpeedModelUpdate) = 5

  val update1 = sls.actorOf(Props(new UpdateModelActor(modelManage)), "update1")

  consumer.run(topicMap.toMap,update1)


}

class UpdateModelActor(modelManage: ServingModelManage) extends Actor with ActorLogging{
  implicit val global = scala.concurrent.ExecutionContext.global

  def receive = {
    case msg:BatchUpdateMessage => {
      Future{
        modelManage.updateBatchModel(msg)
      }

    }
    case msg:SpeedUpdateMessage => {
      Future{
        log.info("receive update Message")
        modelManage.updateSpeedModel(msg)
      }
    }
    case _ => log.debug("receive wrong manage int UpdateModelActor")
  }

}

