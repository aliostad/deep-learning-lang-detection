package processor

import org.apache.camel.builder.RouteBuilder
import org.apache.camel.processor.aggregate.AggregationStrategy
import org.apache.camel.Exchange
import akka.camel._
import akka.actor.ActorRef
import java.util.ArrayList

/**
 * Created with IntelliJ IDEA.
 * User: gguan
 * Date: 11/20/13
 */
class ActiveMQMessageAggregator(source: String, batchSize: Int = 10, receiver: ActorRef) extends RouteBuilder {

  def configure {
    from("activemq:data.%s" format source)
      .setHeader("dequeue", constant(true))
      .aggregate(header("dequeue"), new ArrayListAggregationStrategy())
      .completionSize(batchSize).completionTimeout(1000)
      .to(receiver)
  }

  class ArrayListAggregationStrategy extends AggregationStrategy {

    def aggregate(oldExchange: Exchange, newExchange: Exchange): Exchange = {
      val newBody: Object = newExchange.getIn().getBody();
      if (oldExchange == null) {
        val list = new ArrayList[Object]()
        list.add(newBody)
        newExchange.getIn().setBody(list)
        newExchange
      } else {
        val list = oldExchange.getIn().getBody(classOf[ArrayList[Object]])
        list.add(newBody)
        oldExchange
      }
    }
  }
}
