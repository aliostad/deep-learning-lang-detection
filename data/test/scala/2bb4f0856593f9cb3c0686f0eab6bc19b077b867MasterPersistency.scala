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
package cn.ac.ict.acs.netflow.query.master

import cn.ac.ict.acs.netflow.ha.PersistenceEngine

trait MasterPersistenceEngine extends PersistenceEngine {

  final def addBroker(broker: BrokerInfo): Unit = {
    persist("broker_" + broker.id, broker)
  }

  final def removeBroker(broker: BrokerInfo): Unit = {
    unpersist("broker_" + broker.id)
  }

  final def addJob(job: JobInfo): Unit = {
    persist("job_" + job.id, job)
  }

  final def removeJob(jobId: String): Unit = {
    unpersist("job_" + jobId)
  }

  /**
   * Returns the persisted data sorted by their respective ids (which implies that they're
   * sorted by time of creation).
   */
  final def readPersistedData(): (Seq[JobInfo], Seq[BrokerInfo]) = {
    (read[JobInfo]("job_"), read[BrokerInfo]("broker_"))
  }

}
