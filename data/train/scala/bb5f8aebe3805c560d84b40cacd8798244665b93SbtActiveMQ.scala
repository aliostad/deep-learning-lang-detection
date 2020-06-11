/*
 *
 *  * Copyright 2011-2013 EDC4IT Ltd.
 *  *
 *  * Licensed under the Apache License, Version 2.0 (the "License");
 *  * you may not use this file except in compliance with the License.
 *  * You may obtain a copy of the License at
 *  *
 *  *      http://www.apache.org/licenses/LICENSE-2.0
 *  *
 *  * Unless required by applicable law or agreed to in writing, software
 *  * distributed under the License is distributed on an "AS IS" BASIS,
 *  * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  * See the License for the specific language governing permissions and
 *  * limitations under the License.
 *  
 */

package com.edc4it.sbt.activemq

import sbt.Keys._
import sbt._
import sbt.complete.Parser
import sbt.complete.Parsers._


object SbtActiveMQ extends AutoPlugin {

  object autoImport {

    val amqBrokers = settingKey[Map[String, String]]("broker URLs")

    val amqStart = inputKey[Unit]("start the broker")

    val amqStop = inputKey[Unit]("stop the broker")
    val amqStatus = inputKey[Unit]("List registered brokers")


  }

  import com.edc4it.sbt.activemq.SbtActiveMQ.autoImport._


  var registeredBrokers: scala.collection.mutable.Map[String, Broker] = scala.collection.mutable.Map()


  private val brokerNameParser: Def.Initialize[State => Parser[String]] = {
    Def.setting {
      (state: State) => Space ~> NotSpace.examples(amqBrokers.value.keySet.toList: _*)
    }
  }
  
  override def projectSettings: Seq[Setting[_]] = Seq(
    startBrokerSettings,
    stopBrokerSettings,
    listBrokerSettings,
    amqBrokers := Map("default" -> "broker:tcp://localhost:61616")
  )

  def listBrokerSettings: Setting[_] = amqStatus := {
    println()

    amqBrokers.value.foreach { case (name, brokerURI) =>
      val broker = getBroker(brokerURI, name)
      val status = if (broker.started) "STARTED" else "STOPPED"
      println(s"$name\t${status}\t${broker.uri}")
    }
    println()
  }

  def startBrokerSettings: Setting[_] = amqStart := {
    val name = brokerNameParser.parsed
    amqBrokers.value.get(name) match {
      case Some(brokerURI) => getBroker(brokerURI, name).start()
      case _ => streams.value.log.error(s"No broker URI registered with name $name")
    }
    
  }

  def stopBrokerSettings: Setting[_] = amqStop := {
    val name = brokerNameParser.parsed
      amqBrokers.value.get(name) match {
        case Some(brokerURI) => getBroker(brokerURI,name).stop()
        case _ => streams.value.log.error(s"No broker URI registered with name $name")
      }
  }

  private def getBroker(brokerURI: String, name: String): Broker = {
    registeredBrokers.getOrElseUpdate(brokerURI, new Broker(brokerURI, name))
  }
}







