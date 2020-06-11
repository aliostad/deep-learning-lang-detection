package org.opensplice.mobile.dev.main.paxos

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.main.Manager
import org.opensplice.mobile.dev.paxos.acceptor.AcceptorImpl
import org.opensplice.mobile.dev.tools.DALogger
import org.opensplice.mobile.dev.paxos.TestData

class AcceptorManager(identifier: DDSIdentifier) extends Manager with DALogger {

  val acceptor = AcceptorImpl(identifier, TestData.wire2State)
  logger.info("Created Acceptor")

  override def manageCommand(commands: List[String]) {

    commands match {
      case CLOSE :: Nil => {
        acceptor.close()
      }

      case _ => {}
    }

  }

  override def manageArgs(args: List[String]) {}

}