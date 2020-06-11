package adlive.domain.model.liveConverter.loadBalancer

import adlive.domain.support.{EmptyIdentifier, Identifier}

/**
 * LoadBalancer識別子の基底トレイト
 */
trait LiveConvertLoadBalancerId extends Identifier[String]

object LiveConvertLoadBalancerId {
  def apply(value: String) = ExistLiveConvertLoadBalancerId(value)
}

/**
 * LoadBalancer識別子
 * @param value 識別子の値
 */
case class ExistLiveConvertLoadBalancerId(value: String) extends LiveConvertLoadBalancerId

/**
 * 空の識別子
 */
object EmptyLiveConvertLoadBalancerId extends EmptyIdentifier with LiveConvertLoadBalancerId