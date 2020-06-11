package org.dolphin.manager.domain

import org.dolphin.manager._
import org.dolphin.domain.BrokerModel

/**
 * User: bigbully
 * Date: 14-5-6
 * Time: 上午12:35
 */
class Broker(val model:BrokerModel){
  val id = model.id
  val cluster = model.cluster
  val port = model.port
  val path = ACTOR_ROOT_PATH + "/" + CLUSTER_ROUTER_ACT_NAME + "/" + model.cluster + "/" + BROKER_ROUTER_ACT_NAME + "/" + model.id

  var host = model.host
  var remotePath:String = _
  def this(id:Int, cluster:String, host:String, port:Int, remotePath:String) {
    this(BrokerModel(id, cluster, host, port))
    this.remotePath = remotePath
  }

  def this(model:BrokerModel, remotePath:String){
    this(model)
    this.remotePath = remotePath
  }
  def this(model:BrokerModel, remotePath:String, host:String){
    this(model)
    this.remotePath = remotePath
    this.host = host
  }

  override def toString = {
    "id:" + id + ", cluster:" + cluster + ", host:" + host + ", port:" + port
  }

}

object Broker {
  def apply(model:BrokerModel){
    new Broker(model)
  }

  def apply(model:BrokerModel, remotePath: String) = {
    new Broker(model, remotePath)
  }

  def apply(model: BrokerModel, remotePath: String, host: String): Broker = {
    new Broker(model, remotePath)
  }

  def unapply(broker: Broker) = {
    Some((broker.id, broker.cluster, broker.host, broker.port))
  }
}
