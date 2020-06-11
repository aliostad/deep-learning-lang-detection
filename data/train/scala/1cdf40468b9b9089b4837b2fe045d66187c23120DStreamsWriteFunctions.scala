
package smart.util.io


import smart.app.SMARTStructures._
import org.apache.spark.streaming.dstream.DStream
import smart.util.io.util.IOUtil

class DStreamsWriteFunctions (ds: DStream[String]) {
  def writeToKafkaTopics (kafkaTopicsSink: KafkaTopics): Unit = IOUtil.writeStreamToKafkaTopics(ds, kafkaTopicsSink)
  def writeToRMQExchange (rMQExchangeSink: RMQExchange): Unit = IOUtil.writeStreamToRMQExchange(ds, rMQExchangeSink)
  def writeToRMQQueue (rmqQueueSink: RMQQueue): Unit = IOUtil.writeStreamToRMQQueue(ds, rmqQueueSink)
}


object DStreamsWriteFunctions {
  implicit def addIOfunctions(ds: DStream[String]) = new DStreamsWriteFunctions(ds)
}