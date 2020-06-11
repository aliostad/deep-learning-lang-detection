package adlive.domain.model.liveConverter.loadBalancer

import adlive.domain.model.channel.Channel
import adlive.domain.support.Entity
import adlive.infrastructure.aws.elb.ElbApi
import com.amazonaws.services.ecs.model.LoadBalancer
import com.amazonaws.services.elasticloadbalancing.model.{LoadBalancerDescription, CreateLoadBalancerResult, Listener}

/**
 * ロードバランサー
 * ※IDはaws上のelb name
 * @param id load
 * @param url elb url ライブエンコーダーに設定するURL
 */
case class LiveConvertLoadBalancer(
  id: LiveConvertLoadBalancerId,
  url: String) extends Entity[LiveConvertLoadBalancerId] {
  override val identifier: LiveConvertLoadBalancerId = id

  def toEcsLoadBalancer(escContainerName: String) = {
    new LoadBalancer()
      .withContainerName(escContainerName)
      .withContainerPort(Channel.rtmpPort)
      .withLoadBalancerName(id.value)
  }

  def toHlsLoadBalancer(escContainerName: String) = {
    new LoadBalancer()
      .withContainerName(escContainerName)
      .withContainerPort(Channel.hlsPort)
      .withLoadBalancerName(id.value)
  }
}

object LiveConvertLoadBalancer {
  self =>

  lazy val securityGroupIds = List("sg-3c4d0859")
  lazy val liveListeners = List(
    new Listener("TCP", Channel.rtmpPort, Channel.rtmpPort),
    new Listener("TCP", Channel.hlsPort, Channel.hlsPort)
  )
  lazy val schema = "internet-facing"

  def apply(name: String): LiveConvertLoadBalancer = {
    val id = LiveConvertLoadBalancerId(name)
    self.resolveById(id) match {
      case Some(x) => x
      case _ => self.create(name)
    }
  }

  def resolveById(id: LiveConvertLoadBalancerId): Option[LiveConvertLoadBalancer] = {
    ElbApi.find(id.value).map(self.descriptionToEntity)
  }

  def deleteById(id: LiveConvertLoadBalancerId): Unit = {
    ElbApi.deleteElb(id.value)
  }

  def create(name: String): LiveConvertLoadBalancer = {
    val result: CreateLoadBalancerResult = ElbApi.createElb(name, liveListeners, securityGroupIds, schema)
    self.createResultToEntity(name, result)
  }

  def descriptionToEntity(description: LoadBalancerDescription): LiveConvertLoadBalancer = {
    LiveConvertLoadBalancer(
      id = LiveConvertLoadBalancerId(description.getLoadBalancerName),
      url = description.getDNSName)
  }

  def createResultToEntity(name: String, result: CreateLoadBalancerResult): LiveConvertLoadBalancer = {
    LiveConvertLoadBalancer(id = LiveConvertLoadBalancerId(name), url = result.getDNSName)
  }

}
