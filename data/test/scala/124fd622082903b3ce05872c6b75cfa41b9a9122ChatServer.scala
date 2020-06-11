package scalachat.server

import actors.Actor._
import actors.remote.RemoteActor
import actors.remote.RemoteActor._

import scalachat.common._
import scalachat.common.ChatUtil._
import collection.mutable.HashMap
import actors.{OutputChannel, Actor}

/**
 * @author Mario Fusco
 */
trait ChatManager { this: ChatService =>

  protected def manageChat: Receiver = {
    case MessageEvent(username, message) => {
      sendMessageFrom(username, message)
      println(username + " sent " + message);
    }
  }

  protected def sendMessageFrom(username: String, message: String) =
    sessionsHaving(_ != username).foreach(_ ! MessageEvent(username, message))

  protected def sessionsHaving(filter: String => Boolean): Iterable[Session]
}

trait SessionManager { this: ChatService =>

  val sessions = new HashMap[String, Session]

  protected def manageSession: Receiver = {
    case LoginEvent(username) => {
      sessions.put(username, sender)
      sendMessageFrom(username, "I just logged in")
      println(username + " just logged in")
    }
    case LogoutEvent(username) => {
      sessions.remove(username).get ! LogoutEvent(username)
      sendMessageFrom(username, "I just logged out")
      println(username + " just logged out")
    }
  }

  protected def sessionsHaving(filter: String => Boolean) = sessions.filterKeys(filter).values

  protected def sendMessageFrom(username: String, message: String): Unit
}

trait ChatService extends Actor {

  type Receiver = PartialFunction[scala.Any, scala.Unit]
  type Session = OutputChannel[ChatEvent]

  def act() {
    RemoteActor.classLoader = getClass().getClassLoader()
    alive(chatServicePort)
    register('Server, self)

    loop {
      react {
        manageSession orElse manageChat
      }
    }
  }

  protected def manageSession: Receiver
  protected def manageChat: Receiver
}

object ChatServer extends Application {
  new ChatService with ChatManager with SessionManager start
}