/**
 * Copyright 2015 ICT.
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to You under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package cn.ac.ict.acs.netflow.broker

import akka.actor._
import akka.testkit._
import cn.ac.ict.acs.netflow.DeployMessages._
import cn.ac.ict.acs.netflow.query.broker.RestBroker
import cn.ac.ict.acs.netflow.{Logging, NetFlowConf}
import com.typesafe.config.ConfigFactory

import org.scalatest._

class BrokerSuite(_system: ActorSystem)
  extends TestKit(_system)
  with FunSuiteLike with Matchers with BeforeAndAfterAll
  with DefaultTimeout with PrivateMethodTester with ImplicitSender {

  def this() = this(ActorSystem("BrokerTest",
    ConfigFactory.parseString(BrokerSuite.config)))

  var broker: TestActorRef[RestBroker] = _
  var bareBroker: RestBroker = _
  var dummyMaster: ActorRef = _

  override def beforeAll(): Unit = {
    broker = TestActorRef(
      new RestBroker("fake",19898, 19799,
        Array("netflow-query://fake:7977"),
        Array("akka.tcp://netflowLoadMaster@fake:9099"),
        new NetFlowConf(false)))
    bareBroker = broker.underlyingActor
    dummyMaster = _system.actorOf(Props(new DummyMaster), "dummy")
  }

  override def afterAll(): Unit = {
    shutdown()
  }

  test("Register success") {
    assert(bareBroker.registered == false)
    assert(bareBroker.connected == false)
    assert(bareBroker.master == null)
    broker ! RegisteredBroker("netflow-query://fake:7977", "http://fake:19991")
    assert(bareBroker.registered != false)
    assert(bareBroker.connected != false)
    assert(bareBroker.master != null)
  }

  test("Send heartbeat") {
    broker ! RegisteredBroker("netflow-query://fake:7977", "http://fake:19991")
    bareBroker.master = _system.actorSelection(self.path)
    broker ! SendHeartbeat
    expectMsgType[Heartbeat]
  }

  test("Master changed") {
    broker ! MasterChanged("netflow-query://fake:7977", "http://fake:19991")
    expectMsgType[BrokerStateResponse]
  }
}

object BrokerSuite {
  val config = """
    akka {
      loglevel = "WARNING"
    } """
}

class DummyMaster extends Actor with Logging {
  def receive = {
    case Heartbeat(id) =>
      logDebug(s"heartBeat from $id")
  }
}