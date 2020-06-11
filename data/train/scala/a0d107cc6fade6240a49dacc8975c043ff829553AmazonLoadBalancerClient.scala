package com.lasic.cloud.amazon

import collection.JavaConversions._
import com.amazonaws.services.elasticloadbalancing.AmazonElasticLoadBalancingClient
import com.lasic.util.Logging
import java.lang.String
import com.lasic.cloud.{VM, LoadBalancerClient}
import com.amazonaws.services.elasticloadbalancing.model._

/**
 *
 * @author Brian Pugh
 */

class AmazonLoadBalancerClient(awsLoadBalancingClient: AmazonElasticLoadBalancingClient) extends LoadBalancerClient with Logging {
  def createLoadBalancer(name: String, lbPort: Int, instancePort: Int, protocol: String, sslCertificateId: String, availabilityZones: List[String]): String = {
    val lbRequest = new CreateLoadBalancerRequest().withLoadBalancerName(name)
    lbRequest.setAvailabilityZones(availabilityZones)
    val listener = new Listener().withLoadBalancerPort(lbPort).withInstancePort(instancePort).withProtocol(protocol)
    lbRequest.setListeners(List(listener))
    val dnsName = awsLoadBalancingClient.createLoadBalancer(lbRequest).getDNSName

    logger.debug("created load balancer " + name + ". dns is " + dnsName)

    dnsName
  }


  def deleteLoadBalancer(name: String) {
    logger.debug("deleting load balancer: " + name)

    val deleteRequest = new DeleteLoadBalancerRequest().withLoadBalancerName(name)
    awsLoadBalancingClient.deleteLoadBalancer(deleteRequest)
  }

  def registerWith(loadBalancer: String, vm: VM) {
    val instance = new Instance().withInstanceId(vm.instanceId)
    val regInstanceReq = new RegisterInstancesWithLoadBalancerRequest().withLoadBalancerName(loadBalancer).withInstances(instance)
    awsLoadBalancingClient.registerInstancesWithLoadBalancer(regInstanceReq)
  }
}