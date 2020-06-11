package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.main.Manager

class SGManager(identifier: DDSIdentifier) extends Manager {

  var manager: Option[Manager] = None

  override def manageArgs(args: List[String]) {

    args match {
      case "-g" :: tail => {
        println("g")
        manager = Some(new SGMember(identifier))
        manager.get.manageArgs(tail)
      }

      case "-a" :: tail => {
        println("a")
        manager = Some(new SGAcceptor(identifier))
        manager.get.manageArgs(tail)
      }
      case "-p" :: tail => {
        println("p")
        manager = Some(new SGProposer(identifier))
        manager.get.manageArgs(tail)
      }
      case "-pa" :: tail => {
        manager = Some(new SGColocatedProposerAcceptor(identifier))
        manager.get.manageArgs(tail)
      }
      case "-testlat" :: warmup :: iterations :: tail => {
        val warmupInt = warmup.toInt
        val iterationsInt = iterations.toInt
        println("Latency Test: %d %d".format(warmupInt, iterationsInt))
        manager = Some(new SGTestJL(identifier, warmupInt, iterationsInt))
        // manager.get.manageArgs(tail)
      }
      case "-testlat-col" :: client :: warmup :: iterations :: tail => {
        val warmupInt = warmup.toInt
        val iterationsInt = iterations.toInt
        val clients = client.toInt
        println("Latency Test:%d %d %d".format(clients, warmupInt, iterationsInt))
        manager = Some(new SGAllColocated(identifier, clients, warmupInt, iterationsInt))
        manager.get.manageArgs(tail)
      }

      case _ => {
        println("Stable Group Usage:\n" +
          "-g create standard stable group\n" +
          "-g2 create standard stable group 2\n" +
          "-a create standard acceptor for stable group\n" +
          "-p create standard proposer for stable group\n" +
          "-pa created standard colocated proposer and accceptor for stable group" +
          "-fl create a group member that will always be leader\n" +
          "-testlat <warmup> <iterations> test join/leave latency\n" +
          "-testlat-col <warmup> <iterations> test join/leave latency with all entities colocated\n")
      }
    }
  }

  override def manageCommand(commands: List[String]) {
    if (manager.isDefined) {
      manager.get.manageCommand(commands)
    }
  }

}