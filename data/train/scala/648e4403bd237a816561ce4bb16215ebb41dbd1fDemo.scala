package pubsub

import java.util.UUID

/**
  * @author durga.s
  * @version 2/21/17
  */
object Demo {

  def main(args: Array[String]): Unit = {
    val broker = PubSubBroker(Cluster("demo"))
    broker.createTopic("topic.a", 5)
    val p1 = broker.getProducer("topic.a")

    for(i <- 0 to 50) {
      val m = UUID.randomUUID().toString
      p1.addMessagePartitioned(MessageMetadata(m.getBytes, Array(i.toByte)))
    }

    for(i <- 1 to 5) {
      val c = broker.getConsumer("topic.a")
      while (c.hasNewMessage)
        println(s"consumed ${new String(c.getMessage.message)} via consumer $i")
    }
  }
}
