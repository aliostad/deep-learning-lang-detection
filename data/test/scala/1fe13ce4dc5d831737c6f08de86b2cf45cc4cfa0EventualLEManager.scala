package org.opensplice.mobile.dev.main.le

import org.opensplice.mobile.dev.paxos.TestData
import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.tools.DALogger
import org.opensplice.mobile.dev.main.Manager
import org.opensplice.mobile.dev.leader.EventualLeaderElection

class EventualLEManager(identifier: DDSIdentifier) extends Manager with DALogger {

  import org.opensplice.mobile.dev.leader.EventualLeaderElection.Default._
  val le = EventualLeaderElection(identifier)

  override def manageCommand(commands: List[String]) {

    commands match {
      case CLOSE :: Nil => {
        le.close()
      }

      case _ => {}
    }

  }

  override def manageArgs(args: List[String]) {}

}