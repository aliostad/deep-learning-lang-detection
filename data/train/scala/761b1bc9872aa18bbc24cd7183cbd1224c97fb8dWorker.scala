package com.github.skohar.awsautoscalingdeployment

import cats.std.all._
import cats.syntax.all._
import com.amazonaws.services.autoscaling.AmazonAutoScalingClient
import com.amazonaws.services.autoscaling.model.{DetachLoadBalancersRequest, UpdateAutoScalingGroupRequest}
import com.amazonaws.services.elasticloadbalancing.AmazonElasticLoadBalancingClient
import com.amazonaws.services.elasticloadbalancing.model.LoadBalancerDescription

import scala.collection.JavaConversions._

object Worker {

  val InService = "InService"
  val autoScalingClient = new AmazonAutoScalingClient()
  val elasticLoadBalancingClient = new AmazonElasticLoadBalancingClient()

  def detachAutoScalingGroup(loadBalancerName: String, leaveCount: Int, dryRun: Boolean) = {
    val loadBalancer = findLoadBalancer(loadBalancerName).get
    if (autoScalingClient.describeAutoScalingGroups.getAutoScalingGroups.filter(_.getLoadBalancerNames.toList === loadBalancer.getLoadBalancerName :: Nil).sortBy(_.getCreatedTime).takeRight(leaveCount).flatMap(_.getInstances).forall(_.getLifecycleState === InService)) {
      autoScalingClient.describeAutoScalingGroups.getAutoScalingGroups.filter(_.getLoadBalancerNames.toList === loadBalancer.getLoadBalancerName :: Nil).sortBy(_.getCreatedTime).dropRight(leaveCount).foreach { asg =>
        if (!dryRun) {
          autoScalingClient.detachLoadBalancers(new DetachLoadBalancersRequest().withAutoScalingGroupName(asg.getAutoScalingGroupName).withLoadBalancerNames(loadBalancer.getLoadBalancerName))
        }
        println(s"Detached LoadBalancer(${loadBalancer.getLoadBalancerName}) from AutoScalingGroup(${asg.getAutoScalingGroupName})")
        if (!dryRun) {
          autoScalingClient.updateAutoScalingGroup(new UpdateAutoScalingGroupRequest().withAutoScalingGroupName(asg.getAutoScalingGroupName).withMaxSize(0).withMinSize(0).withDesiredCapacity(0))
        }
        println(s"Updated AutoScalingGroup(${asg.getAutoScalingGroupName}) min=0, desired=0, max=0")
      }
    }
  }

  def findLoadBalancer(loadBalancerName: String): Option[LoadBalancerDescription] = {
    elasticLoadBalancingClient.describeLoadBalancers().getLoadBalancerDescriptions.find(_.getLoadBalancerName === loadBalancerName)
  }
}
