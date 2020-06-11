package com.banno.salat.avro.test

import com.banno.salat.avro._
import global._
import org.apache.avro.Schema

object DateTimeSupportSpec extends SalatAvroSpec {
  import models._

  "a grater for a case class with an datetime field" should {
    "generate an avro schema" in {
      val schema = grater[Neville].asAvroSchema
      println(schema)
      val recordSchema = schema.getTypes().get(0)
      recordSchema must containField("ennui", Schema.Type.BOOLEAN)
      recordSchema must containField("asOf", Schema.Type.STRING)
    }

    "serialize and deserizlize with a org.scala_tools.time.Imports.DateTime" in {
      import org.scala_tools.time.Imports._
      val dt = DateTime.now
      val oldNeville = Neville(asOf = dt)
      val newNeville = serializeAndDeserialize(oldNeville)
      newNeville must_== oldNeville
    }
    
    "serialize and deserizlize with a org.joda.time.DateTime" in {
      import org.joda.time._
      val dt = new DateTime
      val oldNeville = Neville(asOf = dt)
      val newNeville = serializeAndDeserialize(oldNeville)
      newNeville must_== oldNeville
    }
  }
}
