package adt.bson.mongo.bulk

import adt.bson.mongo.WriteError
import adt.bson.{BsonObject, BsonValue}

import scala.language.implicitConversions

/**
 * Avoids name collision with the [[WriteRequest]] Scala version if both are imported.
 */
object JavaBulkModels extends JavaBulkModels
trait JavaBulkModels {
  type JavaBulkWriteError    = com.mongodb.bulk.BulkWriteError
  type JavaBulkWriteResult   = com.mongodb.bulk.BulkWriteResult
  type JavaBulkWriteUpsert   = com.mongodb.bulk.BulkWriteUpsert
  type JavaDeleteRequest     = com.mongodb.bulk.DeleteRequest
  type JavaIndexRequest      = com.mongodb.bulk.IndexRequest
  type JavaInsertRequest     = com.mongodb.bulk.InsertRequest
  type JavaUpdateRequest     = com.mongodb.bulk.UpdateRequest
  type JavaWriteConcernError = com.mongodb.bulk.WriteConcernError
  type JavaWriteRequest      = com.mongodb.bulk.WriteRequest
  type JavaWriteRequestType  = com.mongodb.bulk.WriteRequest.Type
}

object JavaWriteRequest {
  type Type = com.mongodb.bulk.WriteRequest.Type
  object Type {
    final val DELETE = com.mongodb.bulk.WriteRequest.Type.DELETE
    final val INSERT = com.mongodb.bulk.WriteRequest.Type.INSERT
    final val REPLACE = com.mongodb.bulk.WriteRequest.Type.REPLACE
    final val UPDATE = com.mongodb.bulk.WriteRequest.Type.UPDATE
  }
}


/**
 * Constructs a new instance (substitutes [[com.mongodb.bulk.BulkWriteError]]).
 *
 * @param code    the error code
 * @param message the error message
 * @param details details about the error
 * @param index   the index of the item in the bulk write operation that had this error
 */
case class BulkWriteError(code: Int, message: String, details: BsonObject, index: Int) extends WriteError

/**
 * Represents an item in the bulk write that was upserted (substitutes [[com.mongodb.bulk.BulkWriteUpsert]]).
 *
 * @param index the index in the list of bulk write requests that the upsert occurred in
 * @param id the id of the document that was inserted as the result of the upsert
 */
case class BulkWriteUpsert(index: Int, id: BsonValue)
object BulkWriteUpsert {

  implicit def from(upsert: JavaBulkWriteUpsert): BulkWriteUpsert = BulkWriteUpsert(upsert.getIndex, upsert.getId.toBson)
}

/**
 * An error representing a failure by the server to apply the requested write concern to the bulk operation
 * (substitutes [[com.mongodb.bulk.WriteConcernError]]).
 *
 * @param code    the error code
 * @param message the error message
 * @param details any details
 */
case class WriteConcernError(code: Int, message: String, details: BsonObject)
