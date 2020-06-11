package com.banno.salat.avro.test

import com.banno.salat.avro._
import global._
import org.apache.avro.Schema

object ListSupportSpec extends SalatAvroSpec {
  import models._

  "a grater for a case class with an seq field" should {
    "generate an avro schema" in {
      val schema = grater[Clara].asAvroSchema
      val recordSchema = schema.getTypes().get(0)
      println(recordSchema)
      recordSchema must containField("l", Schema.Type.ARRAY)
      recordSchema.getField("l").schema.getElementType.getType must_== Schema.Type.STRING
      recordSchema must containField("m", Schema.Type.ARRAY)
      recordSchema.getField("m").schema.getElementType.getType must_== Schema.Type.INT
    }
    
    "serialize and deserialize" in {
      val oldClara = clara
      println(serializeToJSON(oldClara))
      val newClara = serializeAndDeserialize(oldClara)
      newClara must_== oldClara
    }
  }
  
}
