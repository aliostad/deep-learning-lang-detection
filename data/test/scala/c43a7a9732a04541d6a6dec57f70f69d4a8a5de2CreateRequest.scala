package com.hiperfabric.client.messages.tables

import java.io._

import com.hiperfabric.client.OpCodes._
import com.hiperfabric.io.rpc._
import com.hiperfabric.schema._

class CreateRequest(
  namespace: String,
  name: String,
  columns: Array[Column],
  partitionKeyColumn: String) extends Request {

  override val opCode = CREATE_TABLE

  override def write(out: DataOutput) = {

    // Table.
    out writeUTF namespace
    out writeUTF name

    // Columns.
    val n = columns.length
    out writeInt n
    var i = 0
    while (i < n) {
      val column = columns(i)
      out writeUTF column.name
      out writeByte column.`type`.ordinal
      out writeBoolean column.nullable
      i += 1
    }

    // Partition key.
    if (partitionKeyColumn == null) {
      out writeBoolean false
    } else {
      out writeBoolean true
      out writeUTF partitionKeyColumn
    }
  }
}