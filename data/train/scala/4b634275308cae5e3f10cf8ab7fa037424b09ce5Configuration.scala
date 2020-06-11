package configuration

import com.typesafe.config.ConfigFactory

/**
 * Created by root on 18/12/14.
 */
object Configuration {

  def load: (String) => String = {
    ConfigFactory.load().getString
  }

  lazy val nrOfActorInstances = load ("technoadda.actor.instances")
  lazy val dbHandler = load ("technoadda.actor.dbHandler")
  lazy val dbUrl = load ("technoadda.db.url")
  lazy val dbUser = load ("technoadda.db.user")
  lazy val dbPassword = load ("technoadda.db.password")
  lazy val dbName = load ("technoadda.db.name")


}
