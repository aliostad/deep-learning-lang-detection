package com.databricks.parquet.dsl.write

import scala.collection.JavaConverters._

import org.apache.hadoop.conf.Configuration
import org.apache.parquet.hadoop.api.WriteSupport
import org.apache.parquet.hadoop.api.WriteSupport.WriteContext
import org.apache.parquet.io.api.RecordConsumer
import org.apache.parquet.schema.MessageType

private[dsl] class DirectWriteSupport(schema: MessageType, metadata: Map[String, String])
  extends WriteSupport[RecordBuilder] {

  private var recordConsumer: RecordConsumer = _

  override def init(configuration: Configuration): WriteContext = {
    new WriteContext(schema, metadata.asJava)
  }

  override def write(writeRecord: RecordBuilder): Unit = {
    recordConsumer.startMessage()
    writeRecord(recordConsumer)
    recordConsumer.endMessage()
  }

  override def prepareForWrite(recordConsumer: RecordConsumer): Unit = {
    this.recordConsumer = recordConsumer
  }
}
