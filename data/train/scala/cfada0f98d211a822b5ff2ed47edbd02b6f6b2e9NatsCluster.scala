package com.ecfront.ez.framework.cluster.nats

import com.ecfront.ez.framework.core.cluster._

import scala.beans.BeanProperty

object NatsCluster extends Cluster {

  override val rpc: ClusterRPC = NatsClusterRPC

  override val mq: ClusterMQ = NatsClusterMQ

  override val dist: ClusterDist = null

  override val cache: ClusterCache = null

  override val manage: ClusterManage = NatsClusterManage
}

class MessageWrap {
  @BeanProperty var message: String = _
  @BeanProperty var args: Map[String, String] = _
}
