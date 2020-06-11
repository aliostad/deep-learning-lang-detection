package org.opensplice.mobile.dev.main.paxos

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.main.Manager
import org.opensplice.mobile.dev.common.DAbstractionEvent

class PaxosManager(identifier: DDSIdentifier) extends Manager {

  var manager: Option[Manager] = None

  override def manageArgs(args: List[String]) {

    args match {
      case "-c" :: tail => {
        manager = Some(new ClientManager(identifier))
        manager.get.manageArgs(tail)
      }
      case "-e" :: tail => {
        manager = Some(new ExecutorManager(identifier))
        manager.get.manageArgs(tail)
      }
      case "-a" :: tail => {
        manager = Some(new AcceptorManager(identifier))
        manager.get.manageArgs(tail)
      }
      case "-p" :: tail => {
        manager = Some(new ProposerManager(identifier))
        manager.get.manageArgs(tail)
      }

      case "-tps" :: warmup :: iterations :: tail => {
        val warmupInt = warmup.toInt
        val iterationsInt = iterations.toInt
        manager = Some(new PaxosTestTps(identifier, warmupInt, iterationsInt))
        manager.get.manageArgs(tail)
      }

      case "-lat" :: warmup :: iterations :: tail => {
        val warmupInt = warmup.toInt
        val iterationsInt = iterations.toInt
        manager = Some(new PaxosTestLatency(identifier, warmupInt, iterationsInt))
        manager.get.manageArgs(tail)
      }

      case _ => {
        println("Paxos Usage:\n" +
          "-c create standard client\n" +
          "-e create standard executor\n" +
          "-a create standard acceptor\n" +
          "-p create standard proposer\n" +
          "-tps <warmup> <iterations> create client and executor for tps test\n" +
          "-lat <warmup> <iterations> create client and executor for latency test\n")
      }
    }
  }

  override def manageCommand(commands: List[String]) {
    if (manager.isDefined) {
      manager.get.manageCommand(commands)
      //println("Paxos manager: " + commands)
    }
  }

}