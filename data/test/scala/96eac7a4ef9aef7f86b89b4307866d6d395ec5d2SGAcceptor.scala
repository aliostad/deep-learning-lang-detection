package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.stable.StableGroupAcceptor
import org.opensplice.mobile.dev.group.stable.StableGroup.Default._

class SGAcceptor(identifier: DDSIdentifier) extends GroupManager {

  nuvo.spaces.Config.registerTypes()
  StableGroupAcceptor(identifier)

  override def manageCommand(commands: List[String]) {
  }

  override def manageArgs(args: List[String]) {
    args match {

      case Nil => {

      }

      case _ => {
        println("Stable Group Test Join Leave:\n" +
          "no options! ")
      }
    }
  }

}