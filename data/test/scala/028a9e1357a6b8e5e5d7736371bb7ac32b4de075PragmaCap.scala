/*
* Copyright 2015-2016 Pragmukko Project [http://github.org/pragmukko]
* Licensed under the Apache License, Version 2.0 (the "License"); you may not
* use this file except in compliance with the License. You may obtain a copy of
* the License at
*
*    [http://www.apache.org/licenses/LICENSE-2.0]
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
* WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
* License for the specific language governing permissions and limitations under
* the License.
*/
package builders

import actors.{GCExtentions, SwarmDiscovery, ManageActor}
import akka.actor.{Actor, ActorSystem, Props}
import extentions.web.SwarmHttpService
import utils.ConfigProvider

/**
 * Created by max on 11/5/15.
 */
trait PragmaCap extends ConfigProvider {

  case class GCNodeBuilder[T <: GCExtentions](clusterName:String = config.getString("akka-sys-name"),
                           extentions: List[Class[T]] = List.empty[Class[T]]
                            ) {
    def start(): Unit = {
      val system = ActorSystem(clusterName, config)
      val mgr = system.actorOf(Props[ManageActor], "manager")

      extentions.foreach(c => system.actorOf(Props(c), c.getSimpleName))

    }

    def addExtention[P <: GCExtentions](implicit tag : reflect.ClassTag[P]) = {
      val clzz = tag.runtimeClass.asInstanceOf[Class[T]]
      GCNodeBuilder[T](this.clusterName, clzz :: extentions)
    }

  }

  def build() : GCNodeBuilder[_] = GCNodeBuilder()

  def apply(clusterName:String = config.getString("akka-sys-name")) = {
    val system = ActorSystem(clusterName, config)
    val mgr = system.actorOf(Props[ManageActor], "manager")

    if (config.getBoolean("discovery.start-responder")) {
      SwarmDiscovery.startResponder(system, config)
    }
  }

}

object PragmaCap extends PragmaCap
