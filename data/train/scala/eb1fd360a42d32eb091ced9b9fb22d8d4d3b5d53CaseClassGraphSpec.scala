package com.banno.salat.avro.test

import com.banno.salat.avro._
import global._
import org.apache.avro.Schema

object CaseClassGraphSpec extends SalatAvroSpec {
  import models._

  "a grater for nested case classes" should {
    "generate an avro schema" in {
      val schema = grater[Alice].asAvroSchema
      println(schema)
      val recordSchema = schema.getTypes().get(0)
      recordSchema.getName must_== "Alice"
      recordSchema.getNamespace must_== "com.banno.salat.avro.test.models"
      recordSchema must containField("x", Schema.Type.STRING)
      recordSchema must containField("y", List(Schema.Type.STRING, Schema.Type.NULL))
      recordSchema must containField("z", Schema.Type.RECORD)
      val basilSchema = recordSchema.getField("z").schema
      basilSchema.getName must_== "Basil"
      basilSchema must containField("p", List(Schema.Type.INT, Schema.Type.NULL))
      basilSchema must containField("q", Schema.Type.INT)
    }

    "write to a JSON encoding" in {
      val json = serializeToJSON(graph)
      println(json)
      json must /("com.banno.salat.avro.test.models.Alice") /("x" -> graph.x)
      json must /("com.banno.salat.avro.test.models.Alice") /("y") /("string" -> graph.y.get)
      json must /("com.banno.salat.avro.test.models.Alice") /("z") /("p") /("int" -> graph.z.p.get)
      json must /("com.banno.salat.avro.test.models.Alice") /("z") /("q" -> graph.z.q)
    }

    "serialize and deserialize an object" in {
      val oldGraph = graph()
      val newGraph = serializeAndDeserialize(oldGraph)
      newGraph must_== oldGraph
    }

    "serialize and deserialize an object that was stored in some arbitrary way" in {
      val oldUser = UserAt(User("luke"), Location(2,3))
      val newUser = serializeAndDeserialize(oldUser)
      println("new user = " + newUser)
      newUser must_== oldUser
    }

    "serialize and deserialize an optional nested case class" in {
      val oldFred = Fred(Alice("x", Some("y"), Basil(Some(123))),
                         Some(Clara()))
      val newFred = serializeAndDeserialize(oldFred)
      newFred must_== oldFred
    }
  }
}
