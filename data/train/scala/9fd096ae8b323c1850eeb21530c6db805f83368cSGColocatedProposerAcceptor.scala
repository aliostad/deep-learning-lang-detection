package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.stable.{ StableGroupAcceptor, StableGroupProposer }
import org.opensplice.mobile.dev.paxos.proposer.ProposerImpl.Default._
class SGColocatedProposerAcceptor(identifier: DDSIdentifier) extends GroupManager {

  override def manageCommand(commands: List[String]) {

    commands match {

      case _ => {}
    }

  }

  override def manageArgs(args: List[String]) {
    args match {
      case Nil => {

        Some(StableGroupProposer(identifier))
        StableGroupAcceptor(identifier)
      }

      case "-aq" :: value :: tail => {

        val valueInt = value.toInt

        println("Acceptor Quorum: %d".format(valueInt))

        Some(StableGroupProposer(identifier, valueInt))
        println("Created Proposer, Creating Acceptor")
        StableGroupAcceptor(identifier)
        println("Creater Acceptor")
      }

      case _ => {
        println("Paxos Proposer Usage:\n" +
          "none create standard proposer\n" +
          "-aq <value> create a proposer with value as acceptor quorum ")
      }

    }
  }

}