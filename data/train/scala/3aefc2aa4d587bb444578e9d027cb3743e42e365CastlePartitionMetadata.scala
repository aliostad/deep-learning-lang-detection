package com.box.castle.consumer

import com.box.kafka.Broker
import kafka.api.PartitionMetadata

// $COVERAGE-OFF$

case class CastlePartitionMetadata(leader: Option[Broker],
                                   replicas: Seq[Broker],
                                   isr: Seq[Broker])

object CastlePartitionMetadata {

  def apply(pm: PartitionMetadata): CastlePartitionMetadata = {
    CastlePartitionMetadata(
        pm.leader.map(b => Broker(b.id, b.host, b.port)),
        pm.replicas.map(b => Broker(b.id, b.host, b.port)),
        pm.isr.map(b => Broker(b.id, b.host, b.port))
    )
  }
}
// $COVERAGE-ON$
