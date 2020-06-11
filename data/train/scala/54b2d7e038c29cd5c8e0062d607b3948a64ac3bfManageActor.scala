/*
 *  Copyright 2015 Chiwan Park
 *
 *  Licensed under the Apache License, Version 2.0 (the "License");
 *  you may not use this file except in compliance with the License.
 *  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 *  Unless required by applicable law or agreed to in writing, software
 *  distributed under the License is distributed on an "AS IS" BASIS,
 *  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 *  See the License for the specific language governing permissions and
 *  limitations under the License.
 */

package com.chiwanpark.push.actors

import akka.actor.{Actor, ActorLogging}
import akka.pattern.pipe
import com.chiwanpark.push.database.{CertificateQuery, UserQuery}
import com.chiwanpark.push.services.DatabaseService
import slick.driver.PostgresDriver.api._

object ManageActor {

  case object CreateTable

  case class CreateSuperUser(username: String, password: String)

}

class ManageActor extends Actor with ActorLogging with DatabaseService {

  import ManageActor._
  import context.dispatcher

  implicit val system = context.system

  override def receive: Receive = {
    case CreateTable =>
      val schema = CertificateQuery.schema ++ UserQuery.schema
      db.run(schema.create) pipeTo sender
    case CreateSuperUser(username, password) =>
      val query = UserQuery.insert(username, password)
      db.run(query) pipeTo sender
  }
}
