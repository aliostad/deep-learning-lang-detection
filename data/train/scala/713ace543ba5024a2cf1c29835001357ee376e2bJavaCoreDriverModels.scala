package adt.bson.mongo

import adt.bson.{BsonValue, BsonObject}
import com.mongodb.ErrorCategory

import scala.language.implicitConversions

trait JavaCoreDriverModels {
  type JavaWriteError         = com.mongodb.WriteError
  type JavaWriteConcernResult = com.mongodb.WriteConcernResult
}

/**
 * Represents an error for an item included in a bulk write operation, e.g. a duplicate key error
 * (substitutes [[com.mongodb.WriteError]]).
 */
trait WriteError {

  /**
   * The category of this write error
   */
  def category: ErrorCategory = ErrorCategory.fromErrorCode(code)

  /**
   * The code associated with this error.
   */
  def code: Int

  /**
   * Gets the details associated with this error. This document will not be null, but may be empty.
   */
  def details: BsonObject

  /**
   *Tthe message associated with this error.
   */
  def message: String
}

/**
 * The result of a successful write operation (substitutes [[com.mongodb.WriteConcernResult]]).
 */
sealed trait WriteConcernResult {

  /**
   * Whether the result was acknowledged or not
   */
  def acknowledged: Boolean
}
object WriteConcernResult {

  implicit def from(result: JavaWriteConcernResult): WriteConcernResult = {
    if (result.wasAcknowledged())
      ConfirmedWriteConcernResult(result.getCount, Option(result.getUpsertedId).map(_.toBson), result.isUpdateOfExisting)
    else UnconfirmedWriteConcernResult
  }
}

/**
 * An acknowledged WriteConcernResult (substitutes [[com.mongodb.WriteConcernResult.acknowledged]])
 *
 * @param count the count of matched documents
 * @param upsertedId if an upsert resulted in an inserted document, this is the _id of that document.
 * @param isUpdateOfExisting whether an existing document was updated
 * @return an acknowledged WriteConcernResult
 */
case class ConfirmedWriteConcernResult(count: Int, upsertedId: Option[BsonValue], isUpdateOfExisting: Boolean)
  extends WriteConcernResult {
  override def acknowledged: Boolean = true
}

/**
 * The write was unacknowledged (substitutes [[com.mongodb.WriteConcernResult.unacknowledged]])
 */
case object UnconfirmedWriteConcernResult extends WriteConcernResult {
  override def acknowledged: Boolean = false
}
