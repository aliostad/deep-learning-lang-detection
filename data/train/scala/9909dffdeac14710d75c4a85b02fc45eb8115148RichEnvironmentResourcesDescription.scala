package org.sisioh.aws4s.eb.model

import com.amazonaws.services.elasticbeanstalk.model.{ EnvironmentResourcesDescription, LoadBalancerDescription }
import org.sisioh.aws4s.PimpedType

object EnvironmentResourcesDescriptionFactory {

  def create(): EnvironmentResourcesDescription = new EnvironmentResourcesDescription()

}

class RichEnvironmentResourcesDescription(val underlying: EnvironmentResourcesDescription)
    extends AnyVal with PimpedType[EnvironmentResourcesDescription] {

  def loadBalancerOpt: Option[LoadBalancerDescription] = Option(underlying.getLoadBalancer)

  def loadBalancerOpt_=(value: Option[LoadBalancerDescription]): Unit =
    underlying.setLoadBalancer(value.orNull)

  def withLoadBalancerOpt(value: Option[LoadBalancerDescription]): EnvironmentResourcesDescription =
    underlying.withLoadBalancer(value.orNull)

}
