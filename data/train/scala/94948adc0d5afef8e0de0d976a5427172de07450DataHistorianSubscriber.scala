package historian

import akka.actor._
import akka.stream.actor._
import akka.stream.actor.ActorSubscriberMessage._

class DataHistorianSubscriber(tagBroker : ActorRef) extends ActorSubscriber with ActorLogging {
  val requestStrategy = WatermarkRequestStrategy(25)
  
  // Import the supported messages
  import TagBroker._
  
  def receive = {
    case OnNext(pv: PointValue) =>
      tagBroker ! Dispatch(pv)
    case OnError(err: Exception) => 
      tagBroker ! ShutDown
      context.stop(self)
    case OnComplete => 
      tagBroker ! ShutDown
      context.stop(self)
    case _ =>
  }

}