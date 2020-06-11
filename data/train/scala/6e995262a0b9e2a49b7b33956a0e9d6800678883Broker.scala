
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

import java.nio.file.FileSystems
import java.util.concurrent.atomic.AtomicReference
import java.util.concurrent.locks.ReentrantReadWriteLock

import com.edc4it.sbt.activemq.ContextClassloaderHelper.withRootClassloaderContext
import org.apache.activemq.broker.{BrokerFactory, BrokerService}

import scala.concurrent.ExecutionContext.Implicits.global


class Broker(val uri: String, val name: String) {

  // todo: setup a test -> not sure if this AtomicReference fixes any thread problems, 
  private val _broker: AtomicReference[Option[BrokerService]] = new AtomicReference[Option[BrokerService]](None)

  var startLock = new ReentrantReadWriteLock()
  var starting: AtomicReference[Boolean] = new AtomicReference[Boolean](false)

  def start(): Unit = {

    if (started)
      sys.error("Broker is still running stop it first")

    if (!starting.compareAndSet(false, true)) {
      sys.error(s"Broker is starting")
    }

    try {
      scala.concurrent.future {

        _broker.set(Some(withRootClassloaderContext(BrokerFactory.createBroker(uri, false))))
        val brokerService = _broker.get().get


        val dataDirectory = FileSystems.getDefault.getPath("activemq", "data", name).toFile
        brokerService.setDataDirectoryFile(dataDirectory)
        brokerService.getManagementContext.setConnectorPort(0)
        brokerService.setBrokerName(name)



        brokerService.start()

      }
    } finally {
      starting.set(false)
    }
  }

  def stop(): Unit = {
    if (!started)
      sys.error("Broker is not running")

    _broker.getAndSet(None).foreach(b => b.stop()) // stop a previous broker
  }

  def started = _broker.get.exists(b => b.isStarted)

}
