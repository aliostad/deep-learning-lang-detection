package kafka.cluster

import org.apache.kafka.common.utils.Utils._
import kafka.common.BrokerNotAvailableException
import kafka.common.KafkaException
import kafka.api.ApiUtils._
import java.nio.ByteBuffer
import kafka.utils.Utils._
import kafka.utils.Json

/**
 * @author zhaori
 */
object Broker {
    def createBroker(id: Int, brokerInfoString: String): Broker = {
        if(brokerInfoString == null)
            throw new BrokerNotAvailableException("Broker id %s does not exist".format(id))
        try {
            Json.parseFull(brokerInfoString) match {
                case Some(m) =>
                    val brokerInfo = m.asInstanceOf[Map[String, Any]]
                    val host = brokerInfo.get("host").get.asInstanceOf[String]
                    val port = brokerInfo.get("port").get.asInstanceOf[Int]
                    new Broker(id, host, port)
                case None =>
                    throw new BrokerNotAvailableException("Broker id %s does not exist".format(id))
            }
         } catch {
             case t: Throwable => throw new KafkaException("Failed to parse the broker info from zookeeper: " 
                     + brokerInfoString, t)
         }
    }
    
    def readFrom(buffer: ByteBuffer): Broker = {
        val id = buffer.getInt
        val host = readShortString(buffer)
        val port = buffer.getInt
        new Broker(id, host, port)
    }
}

case class Broker(id: Int, host: String, port: Int) {
    override def toString: String = "id:" + id + ",host:" + host + ",port:" + port
    
    def connectionString: String = formatAddress(host, port)
    
    def writeTo(buffer: ByteBuffer) {
        buffer.putInt(id)
        writeShortString(buffer, host)
        buffer.putInt(port)
    }
    
    def sizeInBytes: Int = shortStringLength(host) + 4 + 4 //hostName + port + brokerId
    
    override def equals(obj: Any): Boolean = {
        obj match {
            case null => false
            case n: Broker => id == n.id && host == n.host && port == n.port
            case _ => false
        }
    }
    
    override def hashCode(): Int = hashcode(id, host, port)
}