package controllers

import play.api._
import play.api.mvc._

import com.google.common.io.Closeables.closeQuietly

import java.io.Closeable
import java.util.Set

import org.jclouds.loadbalancer.domain.LoadBalancerMetadata
import org.jclouds.rackspace.cloudloadbalancers.CloudLoadBalancersApi
import org.jclouds.rackspace.cloudloadbalancers.CloudLoadBalancersAsyncApi
import org.jclouds.rackspace.cloudloadbalancers.domain.NodeRequest
import org.jclouds.rest.RestContext
import org.jclouds.rackspace.cloudloadbalancers.domain.internal.BaseNode._

import scala.collection.JavaConversions._
import scala.collection.JavaConverters._

import utils.LoadBalance

object Loadbalancer extends Controller {

  def index = Action { implicit request =>

    val loadBalance = LoadBalance.getLoadBalancer

    val loadBalancers = loadBalance.listLoadBalancers.toArray.map( _.asInstanceOf[LoadBalancerMetadata] )
    val flashMessage = flash.get("success").getOrElse("")

    Ok(views.html.loadbalancer.index(loadBalancers, flashMessage))
  }

  def view(loadBalancerId: String) = Action { implicit request =>

    val loadBalance = LoadBalance.getLoadBalancer
    val parts = loadBalancerId.split("/")
    val zone = parts(0)
    val id = parts(1).toInt
    val loadBalancer = loadBalance.getLoadBalancerMetadata(loadBalancerId)
    val context =   loadBalance.getContext
    val nova = context.unwrap.asInstanceOf[RestContext[CloudLoadBalancersApi, CloudLoadBalancersAsyncApi]]
    val lbApi =  nova.getApi.getLoadBalancerApiForZone(zone).get(id)
    val nodes = lbApi.getNodes.toArray.map(_.asInstanceOf[org.jclouds.rackspace.cloudloadbalancers.domain.Node])


    Ok(views.html.loadbalancer.view(loadBalancer, nodes))
  }



  def create = TODO

  def edit(loadBalancerId: String) = TODO

  def recreate(loadBalancerId: String) = TODO


  def delete(loadBalancerId: String) = Action { implicit request =>

    val loadBalance = LoadBalance.getLoadBalancer
    val loadBalancer = loadBalance.getLoadBalancerMetadata(loadBalancerId)


    Ok(views.html.loadbalancer.delete(loadBalancer))

  }


  def deleteConfirm(loadBalancerId: String) = Action { implicit request =>


    val loadBalance = LoadBalance.getLoadBalancer
    loadBalance.destroyLoadBalancer(loadBalancerId)


    Redirect(routes.Loadbalancer.index).flashing("success" -> "The load balancer was successfully deleted")

  }

}