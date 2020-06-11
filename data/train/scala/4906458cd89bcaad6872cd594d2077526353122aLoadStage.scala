package controllers.stages

import akka.stream.scaladsl.Flow
import com.datastax.driver.core.Session


/**
  * Flow comprised of a function taking a Cassandra session and some type T.
  * Used to load tweets/hashtags into Cassandra
  *
  * Author: peter.marteen
  */

object LoadStage {

  def getFlow[T](loadFunc : (Session, T) ⇒ Unit)(implicit session : Session) = Flow[T].map(t ⇒ {
    try {
      loadFunc(session, t)
    }
    catch {
      case ex : Throwable ⇒ print(s"Exception caught: ${ex.getMessage} \n")
    }
    t
  })
}