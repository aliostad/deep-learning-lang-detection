package flumina

import scodec.bits.BitVector

import scala.concurrent.duration._

final case class KafkaSettings(
    bootstrapBrokers: Seq[KafkaBroker.Node],
    connectionsPerBroker: Int,
    operationalSettings: KafkaOperationalSettings,
    requestTimeout: FiniteDuration
)

final case class KafkaOperationalSettings(
    retryBackoff: FiniteDuration,
    retryMaxCount: Int,
    fetchMaxWaitTime: FiniteDuration,
    fetchMaxBytes: Int,
    produceTimeout: FiniteDuration,
    groupSessionTimeout: FiniteDuration
)

sealed trait KafkaBroker

object KafkaBroker {
  final case class Node(host: String, port: Int) extends KafkaBroker
  final case object AnyNode                      extends KafkaBroker
}

final case class KafkaConnectionRequest(apiKey: Int, version: Int, requestPayload: BitVector, trace: Boolean)

final case class KafkaBrokerRequest(broker: KafkaBroker, request: KafkaConnectionRequest) {
  def matchesBroker(other: KafkaBroker): Boolean = broker match {
    case KafkaBroker.AnyNode               => true
    case n: KafkaBroker if n.equals(other) => true
    case _                                 => false
  }
}

final case class KafkaContext(
    broker: KafkaBroker,
    settings: KafkaOperationalSettings
)
