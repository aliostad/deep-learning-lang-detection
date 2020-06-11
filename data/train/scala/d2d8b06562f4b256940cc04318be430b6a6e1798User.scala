package models

import org.joda.time.{DateTime, DateTimeZone}
import utils.StringUtils

import scala.concurrent.Future

case class User(
    id:                       String               = StringUtils.generateUuid,
    created_at:               Option[DateTime]     = Some(DateTime.now(DateTimeZone.UTC)),
    created_by:               Option[String]       = None,
    email:                    String,
    password:                 String,
    first_name:               Option[String]       = None,
    last_name:                Option[String]       = None,
    deleted_at:               Option[DateTime]     = None
)

class UserService {

  // use your own system to manage your user
  def loadById(id:String):Future[Option[User]] = ???
  def findByEmail(email:String):Future[Option[User]] = ???

}
