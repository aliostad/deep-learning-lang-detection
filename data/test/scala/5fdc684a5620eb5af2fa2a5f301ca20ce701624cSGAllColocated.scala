package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.stable.{ StableGroupAcceptor, StableGroupProposer }

class SGAllColocated(identifier: DDSIdentifier, val clientNum: Int, val WARMUP: Int, val TEST: Int) extends GroupManager {

  import org.opensplice.mobile.dev.group.stable.StableGroup.Default._

  import org.opensplice.mobile.dev.paxos.proposer.ProposerImpl.Default._

  StableGroupProposer(identifier)
  StableGroupAcceptor(identifier)

  class ClientThread() extends Runnable {
    override def run {
        new SGTestJL(identifier, WARMUP, TEST)
    }
  }

  for (i <- 0 to (clientNum - 1))
    new Thread(new ClientThread()).start()

  override def manageCommand(commands: List[String]) {
  }

  override def manageArgs(args: List[String]) {
    args match {
      case Nil => {

      }
      
      case e: Any => {
        println(e)
        println("Stable Group Test Join Leave:\n" +
          "no options! ")
      }

    }
  }

}