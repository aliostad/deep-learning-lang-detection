/**
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 * 
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package kafka.cluster

import kafka.utils.Utils._
import kafka.utils.Json
import kafka.api.ApiUtils._
import java.nio.ByteBuffer
import kafka.common.{KafkaException, BrokerNotAvailableException}
import org.apache.kafka.common.utils.Utils._

/**
 * A Kafka broker
 * id、host、port组成一个节点
 */
object Broker {

  //brokerInfoString是一个json字符串,从该字符串中创建Broker对象
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
          throw new BrokerNotAvailableException("Broker id %d does not exist".format(id))
      }
    } catch {
      case t: Throwable => throw new KafkaException("Failed to parse the broker info from zookeeper: " + brokerInfoString, t)
    }
  }

  //从buffer中还原Broker对象
  def readFrom(buffer: ByteBuffer): Broker = {
    val id = buffer.getInt
    val host = readShortString(buffer)
    val port = buffer.getInt
    new Broker(id, host, port)
  }
}

case class Broker(id: Int, host: String, port: Int) {
  
  override def toString: String = "id:" + id + ",host:" + host + ",port:" + port

  def connectionString: String = formatAddress(host, port)//相当于toString方法

  //将id、host、port写入到ByteBuffer中
  def writeTo(buffer: ByteBuffer) {
    buffer.putInt(id)
    writeShortString(buffer, host)//记录host到buffer中
    buffer.putInt(port)
  }

  //存储一个broker需要多少字节,host字符串的长度所需字节+port和id的int值4个字节
  def sizeInBytes: Int = shortStringLength(host) /* host name */ + 4 /* port */ + 4 /* broker id*/

  override def equals(obj: Any): Boolean = {
    obj match {
      case null => false
      case n: Broker => id == n.id && host == n.host && port == n.port
      case _ => false
    }
  }
  
  override def hashCode(): Int = hashcode(id, host, port)
  
}
