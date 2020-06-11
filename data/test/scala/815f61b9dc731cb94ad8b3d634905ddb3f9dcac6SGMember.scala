package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.stable.StableGroup
import org.opensplice.mobile.dev.group.stable.StableGroup.Default.{defaultClientFactory, defaultExecutorFactory, defaultLeaderFactory}

class SGMember(identifier: DDSIdentifier) extends GroupManager {

  nuvo.spaces.Config.registerTypes()
  val group = StableGroup(identifier)

  override def manageCommand(commands: List[String]) {

    commands match {

      case JOIN :: Nil => {
        group.join()
      }
      case LEAVE :: Nil => {
        group.leave()
      }
      case CLOSE :: Nil => {
        group.close()
      }

      case _ => {}
    }

  }

  override def manageArgs(args: List[String]) {
    args match {
      case Nil => {

      }

      case "-j" :: tail => {
        group.join()
      }

      case _ => {
        println("Stable Group MemberUsage:\n" +
          "none create standard stable group member\n" +
          "-j create standard stable group member and join ")
      }
    }
  }

}