/**
 * Copyright (C) 2012 FuseSource Corp. All rights reserved.
 * http://fusesource.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package org.fusesource.mq.leveldb

import org.apache.activemq.broker.BrokerService
import org.apache.activemq.broker.BrokerTest
import org.apache.activemq.store.PersistenceAdapter
import java.io.File
import junit.framework.{TestSuite, Test}

/**
 * @author <a href="http://hiramchirino.com">Hiram Chirino</a>
 */
object LevelDBStoreBrokerTest {
  def suite: Test = {
    return new TestSuite(classOf[LevelDBStoreBrokerTest])
  }

  def main(args: Array[String]): Unit = {
    junit.textui.TestRunner.run(suite)
  }
}

class LevelDBStoreBrokerTest extends BrokerTest {

  protected def createPersistenceAdapter(delete: Boolean): PersistenceAdapter = {
    var store: LevelDBStore = new LevelDBStore
    store.setDirectory(new File("target/activemq-data/leveldb"))
    if (delete) {
      store.deleteAllMessages
    }
    return store
  }

  protected override def createBroker: BrokerService = {
    var broker: BrokerService = new BrokerService
    broker.setPersistenceAdapter(createPersistenceAdapter(true))
    return broker
  }

  protected def createRestartedBroker: BrokerService = {
    var broker: BrokerService = new BrokerService
    broker.setPersistenceAdapter(createPersistenceAdapter(false))
    return broker
  }
}