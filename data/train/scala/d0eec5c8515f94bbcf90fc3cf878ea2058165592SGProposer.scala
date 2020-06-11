package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.stable.StableGroupProposer
import org.opensplice.mobile.dev.paxos.proposer.ProposerImpl.Default._
class SGProposer(identifier: DDSIdentifier) extends GroupManager {

  override def manageCommand(commands: List[String]) {
  }

  override def manageArgs(args: List[String]) {
    args match {
      case Nil => {

        Some(StableGroupProposer(identifier))

      }

      case "-aq" :: value :: tail => {

        val valueInt = value.toInt

        println("Acceptor Quorum: %d".format(valueInt))

        Some(StableGroupProposer(identifier, valueInt))
      }

      case _ => {
        println("Paxos Proposer Usage:\n" +
          "none create standard proposer\n" +
          "-aq <value> create a proposer with value as acceptor quorum ")
      }

    }
  }

}