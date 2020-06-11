package org.opensplice.mobile.dev.main.paxos

import org.opensplice.mobile.dev.paxos.TestData
import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.paxos.event.ReceivedDecide
import org.opensplice.mobile.dev.paxos.executor.ExecutorImpl
import org.opensplice.mobile.dev.tools.DALogger
import org.opensplice.mobile.dev.main.Manager

class ExecutorManager(identifier: DDSIdentifier) extends Manager with DALogger {

  val executor = ExecutorImpl(identifier, TestData.wire2State)
  executor.events += {
    case ReceivedDecide(_, _, k, op, e, value) => {

      logger.info("[%d] Received decide op %d with value %s for epoch %d".format(k, op, value, e))

    }

    case _ => logger.debug("?")
  }

  override def manageCommand(commands: List[String]) {

    commands match {
      case CLOSE :: Nil => {
        executor.close()
      }

      case _ => {}
    }

  }

  override def manageArgs(args: List[String]) {}

}