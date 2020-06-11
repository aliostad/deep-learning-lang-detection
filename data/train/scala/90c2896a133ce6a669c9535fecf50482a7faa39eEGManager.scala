package org.opensplice.mobile.dev.main.group

import org.opensplice.mobile.dev.common.DDSIdentifier
import org.opensplice.mobile.dev.group.eventual.EventualGroup

class EGManager(identifier: DDSIdentifier) extends GroupManager {

  
  val group = EventualGroup(identifier)

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
  
  override def manageArgs(args: List[String]) {}

}