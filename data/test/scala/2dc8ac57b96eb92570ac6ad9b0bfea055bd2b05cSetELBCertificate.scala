package com.ocelotconsulting.ssl.aws.ec2

import com.amazonaws.services.elasticloadbalancing.model.{SetLoadBalancerListenerSSLCertificateRequest, SetLoadBalancerListenerSSLCertificateResult}
import com.amazonaws.services.elasticloadbalancing.{AmazonElasticLoadBalancing, AmazonElasticLoadBalancingClient}

/**
  * Created by Larry Anderson on 10/8/16.
  */
object SetELBCertificate {
  val elbClient: AmazonElasticLoadBalancing = new AmazonElasticLoadBalancingClient()

  def apply(loadBalancerName: String, loadBalancerPort: Int, sSLCertificateId: String): SetLoadBalancerListenerSSLCertificateResult = {
    val req: SetLoadBalancerListenerSSLCertificateRequest = new SetLoadBalancerListenerSSLCertificateRequest(loadBalancerName, loadBalancerPort, sSLCertificateId)
    elbClient.setLoadBalancerListenerSSLCertificate(req)
  }
}
