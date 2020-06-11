package com.banno.salat.avro.test

import com.banno.salat.avro._
import global._
import org.apache.avro.Schema

object SetSupportSpec extends SalatAvroSpec {
  import models._

  "a grater for a case class with an set field" should {
    "generate an avro schema" in {
      val schema = grater[HasASet].asAvroSchema
      val recordSchema = schema.getTypes().get(0)
      println(recordSchema)
      recordSchema must containField("s", Schema.Type.ARRAY)
      recordSchema.getField("s").schema.getElementType.getType must_== Schema.Type.INT
    }

    "serialize and deserialize" in {
      val old = HasASet(Set(1,2,3))
      println(serializeToJSON(old))
      val newO = serializeAndDeserialize(old)
      newO must_== old
    }
  }

}
