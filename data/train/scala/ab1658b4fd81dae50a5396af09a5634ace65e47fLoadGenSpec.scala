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

package com.example.fapi.data

import akka.actor.ActorSystem
import akka.pattern.ask
import akka.testkit.{ TestActorRef, TestKit }
import akka.util.Timeout
import com.example.fapi.data.LoadRepository.GetLastLoads
import com.example.fapi.data.sources.LoadGen
import com.example.fapi.data.sources.LoadGen.GenLoad
import org.scalatest.{ AsyncFreeSpecLike, Matchers }

import scala.concurrent.Future
import scala.concurrent.duration._

class LoadGenSpec extends TestKit(ActorSystem("LoadRepoSpec")) with AsyncFreeSpecLike with Matchers {

  implicit val timeout: Timeout = 10 seconds
  val repo = TestActorRef(new LoadRepository)
  val loadGen = TestActorRef(new LoadGen(repo))

  "generating Load data" - {

    "should gen single load per machine" in {

      val getLoad: Future[List[Load]] = (repo ? GetLastLoads).mapTo[List[Load]]
      getLoad map { loads =>
        loads.size should be(0)
      }
      loadGen ! GenLoad

      Thread.sleep(100)

      val getLoadAfter: Future[List[Load]] = (repo ? GetLastLoads).mapTo[List[Load]]
      getLoadAfter map { loads =>
        loads.size should be(4) // one for each machine
      }
    }
  }
}
