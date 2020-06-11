package io.darwin.afka.domain

import io.darwin.afka.packets.responses.BrokerResponse
import io.darwin.afka.util.ArrayCompare

/**
  * Created by darwin on 3/1/2017.
  */
case class Broker
  ( val nodeId : Int,
    val host   : String,
    val port   : Int,
    val rack   : Option[String]) {

  override def equals(obj: Any): Boolean = {
    obj match {
      case that: Broker ⇒
        nodeId == that.nodeId &&
        host   == that.host &&
        port   == that.port &&
        rack   == that.rack
      case _ ⇒ false
    }
  }

  override val toString = {
    s"node=${nodeId}, host=${host}, port=${port}, rack=${rack}"
  }
}

object Broker {
  def apply(b: BrokerResponse) = new Broker(b.nodeId, b.host, b.port, b.rack)
}

class Brokers(b: Array[BrokerResponse]) {

  val length                 = b.length
  val brokers: Array[Broker] = b.sortBy(_.nodeId).map(Broker(_))
  val map: Map[Int, Broker]  = brokers.map(b ⇒ (b.nodeId, b)).toMap

  override val toString = {
    brokers.mkString("\n")
  }

  override def equals(obj: scala.Any): Boolean = {
    obj match {
      case that: Brokers               ⇒ ArrayCompare(brokers, that.brokers)
      case that: Array[BrokerResponse] ⇒ ArrayCompare(brokers, Brokers(that).brokers)
      case _                           ⇒ false
    }
  }

  def apply(i: Int)   : Broker         = brokers(i)
  def get(node: Int)  : Option[Broker] = map.get(node)
  def byIndex(i: Int) : Broker         = brokers(i)
}

object Brokers {
  def apply(b: Array[BrokerResponse]) = new Brokers(b)
}
