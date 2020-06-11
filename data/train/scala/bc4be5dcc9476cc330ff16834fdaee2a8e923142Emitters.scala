package com.soundcloud.sketchy.agent

import com.soundcloud.sketchy.broker.HaBroker
import com.soundcloud.sketchy.events.{ JSON, Event, SketchySignal }

/**
 * Rabbit Sink
 */
abstract class RabbitEmitterAgent(
  broker: HaBroker,
  exchange: String,
  key: String) extends Agent {

  val producer = broker.producer

  def publish(string: String) {
    producer.publish(exchange, key, string)
  }
}

/**
 * Emit sketchy signals back onto the message bus.
 */
class SignalEmitterAgent(
  broker: HaBroker,
  exchange: String,
  key: String) extends RabbitEmitterAgent(broker, exchange, key) {

  import com.soundcloud.sketchy.events.writers._

  def on(event: Event): Seq[Event] = {
    event match {
      case signal: SketchySignal => {
        publish(JSON.jsonPretty(signal))
        signal :: Nil
      }
      case _ => Nil
    }
  }

}
