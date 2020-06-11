package models

import java.util.UUID

import config.ConfigBanana
import org.w3.banana.{FOAFPrefix, PointedGraph, XSDPrefix}
import org.w3.banana.binder.PGBinder
import play.api.libs.json.Json

import scala.language.implicitConversions
import scala.util.Try

/** Describes a verification of a task by a user.
  *
  * @param time unix time in milliseconds
  */
case class Verification(_id: UUID,
                        verifier_id: UUID,
                        task_id: UUID,
                        time: Long,
                        value: Option[Boolean]
                       ) extends MongoEntity

object Verification extends ConfigBanana {
  implicit val verificationFormat = Json.format[Verification]
}

/** Binds verification case class to rdf. Unfinished
  *
  */
case class VerificationDump(
                          _id: UUID,
                          verifier: String,
                          link: Link,
                          value: Option[Boolean]
                           )

object VerificationDump extends ConfigBanana {

    import ops._
    import recordBinder._
    import org.w3.banana.syntax._

    val veritaskPrefix = "http://www.veritask.de/"

    val _id = property[UUID](URI(veritaskPrefix + "verification_id"))
    val verifier = property[String](URI(veritaskPrefix + "verifier"))
    val link= property[Link](URI(veritaskPrefix + "link"))
    val value = optional[Boolean](URI(veritaskPrefix + "value"))

    implicit val binder: PGBinder[Rdf, VerificationDump] =
      pgbWithId[VerificationDump](t => URI(veritaskPrefix + t._id))
        .apply(_id, verifier, link, value)(VerificationDump.apply, VerificationDump.unapply)
}
