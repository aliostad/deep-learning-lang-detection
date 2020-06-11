package com.banno.salat.avro.test

import com.banno.salat.avro._
import global._
import org.apache.avro.Schema

object EnumSupportSpec extends SalatAvroSpec {
  import models._

  "a grater for a case class with an enum field" should {
    "generate an avro schema" in {
      val schema = grater[Me].asAvroSchema
      println(schema)
      val recordSchema = schema.getTypes().get(0)
      recordSchema must containField("state", Schema.Type.STRING)
    }

    "serialize and deserilize" in {
      val oldMe = Me("luke")
      val newMe = serializeAndDeserialize(oldMe)
      newMe must_== oldMe
    }
  }
}
