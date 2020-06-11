package utils.advert

import akka.actor.{ReceiveTimeout, Actor}
import anorm._
import play.api.Play.current
import play.api.db.DB
import utils._

import scala.concurrent.duration._
import scala.language.postfixOps
import scala.util.{Failure, Try}

class AccountManager extends Actor {
  override def receive = {
    case "Start" =>
      context.setReceiveTimeout(30 minutes)
    case ReceiveTimeout =>
      AccessLogger.debug("Begin to manage advertisers accounts periodically")

      Try(DB.withTransaction { implicit c =>
        SQL("select advert.manage_accounts(NULL)").execute()
      }) match {
        case Failure(ex) => AccessLogger.error(s"Fail to manage advertisers accounts periodically: ${ex.getMessage}")
        case _ => AccessLogger.debug("Managing advertisers accounts completes once")
      }
    case "Stop" =>
      context.setReceiveTimeout(Duration.Undefined)
  }
}
