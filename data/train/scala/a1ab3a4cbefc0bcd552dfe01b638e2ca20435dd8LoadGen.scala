/*
 * Copyright 2016 ksilin
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.example.fapi.data.sources

import akka.actor.{ Actor, ActorLogging, ActorRef, Props }
import com.example.fapi.data.LoadRepository.{ DeleteLoadsBefore, StoreLoad }
import com.example.fapi.data.sources.LoadGen.{ GenLoad, Purge }
import com.example.fapi.data.{ Load, LoadRepository }
import com.example.fapi.http.ClusterConfig
import org.joda.time.DateTime

import scala.util.Random

object LoadGen {

  case object GenLoad
  case object Purge

  final val Name = "loadgen"

  def props(repo: ActorRef) = Props(new LoadGen(repo))
}

class LoadGen(loadRepo: ActorRef) extends Actor with ActorLogging with ClusterConfig {

  //  val repo = context.actorOf(LoadRepository.props())

  override def receive: Receive = {
    case GenLoad =>
      machines foreach { machine =>
        // TODO - use machine stats to generate more plausible loads
        log.debug(s"generating load for machine $machine")
        loadRepo ! StoreLoad(randomLoad(machine))
      }
    case Purge => loadRepo ! DeleteLoadsBefore(DateTime.now.minusMinutes(15))
  }

  def randomLoad(machine: String) = Load(machine, Random.nextInt(80), Random.nextInt(80), 10000L)
}
