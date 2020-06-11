package chatless.ops
import chatless._
import chatless.db.WriteStat
import chatless.model.{User, JDoc}
import akka.actor.ActorRef

trait UserOps {
  def getOrThrow(uid: UserId): User

  def setNick(cid: UserId, value: String): WriteStat

  def setPublic(cid: UserId, value: Boolean): WriteStat

  def setInfo(cid: UserId, value: JDoc): WriteStat

  def followUser(cid: UserId, uid: UserId): WriteStat

  def unfollowUser(cid: UserId, uid: UserId): WriteStat

  def removeFollower(cid: UserId, uid: UserId): WriteStat

  def blockUser(cid: UserId, uid: UserId): WriteStat

  def unblockUser(cid: UserId, uid: UserId): WriteStat

  def joinTopic(cid: UserId, tid: TopicId): WriteStat

  def leaveTopic(cid: UserId, value: TopicId): WriteStat

  def addTag(cid: UserId, value: String): WriteStat

  def removeTag(cid: UserId, value: String): WriteStat
}

