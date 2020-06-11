package com.evojam.mongodb.client.model

import scala.collection.JavaConversions._
import scala.language.implicitConversions

import com.mongodb.MongoNamespace
import com.mongodb.WriteConcern
import com.mongodb.bulk.WriteRequest
import com.mongodb.operation.MixedBulkWriteOperation

case class WriteOperation(
  namespace: MongoNamespace,
  writeRequests: List[_ <: WriteRequest],
  ordered: Boolean,
  writeConcern: WriteConcern) {

  require(namespace != null, "namespace cannot be null")
  require(writeRequests != null, "writeRequests cannot be null")
  require(writeRequests.nonEmpty, "writeRequests cannot be empty")
  require(writeConcern != null, "writeConcern cannot be null")
}

object WriteOperation {
  implicit def writeOperation2MixedBulkWriteOperation(op: WriteOperation): MixedBulkWriteOperation =
    new MixedBulkWriteOperation(op.namespace, op.writeRequests, op.ordered, op.writeConcern)
}
