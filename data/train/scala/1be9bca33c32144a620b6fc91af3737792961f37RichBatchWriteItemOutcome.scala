package org.sisioh.aws4s.dynamodb.document

import com.amazonaws.services.dynamodbv2.document.BatchWriteItemOutcome
import com.amazonaws.services.dynamodbv2.model.{ BatchWriteItemResult, WriteRequest }
import org.sisioh.aws4s.PimpedType

import scala.collection.JavaConverters._

object BatchWriteItemOutcomeFactory {

  def apply(bwir: BatchWriteItemResult): BatchWriteItemOutcome = new BatchWriteItemOutcome(bwir)

}

class RichBatchWriteItemOutcome(val underlying: BatchWriteItemOutcome) extends AnyVal with PimpedType[BatchWriteItemOutcome] {

  def unprocessedItems: Map[String, Seq[WriteRequest]] =
    underlying.getUnprocessedItems.asScala.map(e => (e._1, e._2.asScala)).toMap

}
