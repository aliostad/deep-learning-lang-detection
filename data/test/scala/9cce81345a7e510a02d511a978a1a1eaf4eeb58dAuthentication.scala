package tool

import models.req.AuthData
import models.db

import scala.util.Random
import java.security.MessageDigest
import play.Logger
import com.ponkotuy.data.{ MyFleetAuth, Auth }

/**
 *
 * @author ponkotuy
 * Date: 14/05/26.
 */
object Authentication {
  val StretchCount = 971

  def oldAuth(auth: Auth): Option[db.Admiral] = {
    db.Admiral.find(auth.memberId) match {
      case Some(old: db.Admiral) if old.authentication(auth) => Some(old)
      case Some(_) => None
      case _ => Some(db.Admiral.create(auth))
    }
  }

  def myfleetAuth(memberId: Long, pass: String): Boolean = {
    db.MyFleetAuth.find(memberId).filter { auth =>
      toHash(pass, auth.salt) sameElements auth.hash
    }.isDefined
  }

  def myfleetAuth(auth: AuthData): Boolean = myfleetAuth(auth.userId, auth.password)

  def myfleetAuthOrCreate(auth: MyFleetAuth): Boolean = {
    db.MyFleetAuth.find(auth.id) match {
      case Some(old) if toHash(auth.pass, old.salt) sameElements old.hash => true
      case Some(old) => false
      case None =>
        createAccount(auth)
        true
    }
  }

  def createAccount(auth: MyFleetAuth): Unit = {
    var salt = new Array[Byte](32)
    (new Random).nextBytes(salt)
    db.MyFleetAuth.create(auth.id, toHash(auth.pass, salt), salt, System.currentTimeMillis())
    Logger.info("Create New MyFleetAuth")
  }

  def toHash(pass: String, salt: Array[Byte]): Array[Byte] = {
    val sha256 = MessageDigest.getInstance("SHA-256")
    var result = pass.getBytes
    (1 to StretchCount).map { _ =>
      result = sha256.digest(result ++ salt)
    }
    result
  }
}
