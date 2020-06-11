package com.thangiee.lolhangouts.data.usecases

import com.thangiee.lolchat.LoLChat
import com.thangiee.lolchat.error.{NoSession, NotConnected, NotFound}
import com.thangiee.lolhangouts.data.Cached
import com.thangiee.lolhangouts.data.usecases.ManageFriendUseCase._
import com.thangiee.lolhangouts.data._
import org.scalactic.Or

import scala.concurrent.ExecutionContext.Implicits.global
import scala.concurrent.Future

trait ManageFriendUseCase extends Interactor {
  def sendFriendRequest(toName: String): Future[Unit Or ManageFriendError]
  def removeFriend(summId: String): Future[Unit Or ManageFriendError]
  def createGroup(groupName: String): Future[Unit Or ManageFriendError]
  def moveFriendToGroup(friendName: String, groupName: String): Future[Unit Or ManageFriendError]
}

object ManageFriendUseCase {
  sealed trait ManageFriendError
  object FriendNotFound extends ManageFriendError
  object NoConnection extends ManageFriendError
  object InternalError extends ManageFriendError
}

case class ManageFriendUseCaseImpl() extends ManageFriendUseCase {

  override def sendFriendRequest(toName: String): Future[Unit Or ManageFriendError] = Future {
    import CacheIn.Memory._

    summonerByName(toName) match {
      case Good(summoner) =>
        LoLChat.findSession(Cached.loginUsername).flatMap { sess =>
          info(s"[+] friend request sent to $toName")
          sess.sendFriendRequest(summoner.id.toString)
        } badMap {
          case NoSession(msg)  => warn(s"[!] Cannot send friend request because: $msg"); InternalError
          case NotConnected(_) => warn("[!] No connection to send friend request"); NoConnection
        }

      case Bad(DataNotFound)    => info(s"[-] Unable to find summoner $toName"); Bad(FriendNotFound)
      case Bad(BadRequest(url)) => info(s"[-] Bad url: $url");                   Bad(FriendNotFound)
      case Bad(e: RiotError)    => info(s"[!] Riot api error: ${e.toString}");   Bad(InternalError)
    }
  }

  def removeFriend(summId: String): Future[Unit Or ManageFriendError] = Future {
    LoLChat.findSession(Cached.loginUsername).flatMap { sess =>
      info(s"[+] friend $summId removed")
      sess.removeFriend(summId)
    } badMap {
      case NoSession(msg)  => warn(s"[!] Cannot remove friend because $msg"); InternalError
      case NotConnected(_) => warn("[!] No connection. Can't remove friend."); NoConnection
    }
  }

  def createGroup(groupName: String): Future[Unit Or ManageFriendError] = Future {
    LoLChat.findSession(Cached.loginUsername).map { sess =>
      info(s"[+] create new friend group")
      sess.createFriendGroup(groupName)
    } badMap {
      case NoSession(msg) => warn(s"[!] Cannot create group because $msg"); InternalError
    }
  }

  def moveFriendToGroup(friendName: String, groupName: String): Future[Unit Or ManageFriendError] = Future {
    (for {
      sess ← LoLChat.findSession(Cached.loginUsername)
      friend ← sess.findFriendByName(friendName)
    } yield {
        info(s"[+] moving $friendName to $groupName")
        sess.moveFriendToGroup(friend, groupName)
      }) badMap {
      case NoSession(msg) => warn(s"[!] Cannot create group because $msg"); InternalError
      case NotFound(_)       =>
        info(s"[-] Fail to move $friendName to $groupName name. Can't find name in friend list.")
        FriendNotFound
    }
  }
}
