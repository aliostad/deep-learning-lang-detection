package org.sisioh.aws4s.eb.model

import com.amazonaws.services.elasticbeanstalk.model.LoadBalancer
import org.sisioh.aws4s.PimpedType

object LoadBalancerFactory {

  def create(): LoadBalancer = new LoadBalancer()

}

class RichLoadBalancer(val underlying: LoadBalancer)
    extends AnyVal with PimpedType[LoadBalancer] {

  def nameOpt: Option[String] = Option(underlying.getName)

  def nameOpt_=(value: Option[String]): Unit =
    underlying.setName(value.orNull)

  def withNameOpt(value: Option[String]): LoadBalancer =
    underlying.withName(value.orNull)

}
