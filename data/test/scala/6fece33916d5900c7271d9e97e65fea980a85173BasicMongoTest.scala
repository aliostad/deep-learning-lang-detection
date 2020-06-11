package test.mongodb

import com.mongodb.casbah.Imports._
import org.scalatest.FeatureSpec

class BasicMongoSpec extends FeatureSpec {
  var mongoDB: MongoCollection = _
  
  feature("Basic database operations") {
    scenario("a simple database is created") {
      val mongoClient = MongoClient()
      mongoDB = mongoClient("casbah_test")("test_data")
      assert(mongoDB.size === 0)
    }

    scenario("an entry is added to the database using DBObject mappings") {
      val newObj = 
        MongoDBObject(
          "foo" -> "bar",
          "x" -> "y",
          "pie" -> 3.14,
          "spam" -> "eggs"
        )
      newObj += "coolfactor" -> (9001: java.lang.Integer)

      val oldLength = mongoDB.size
      mongoDB += newObj
      assert(mongoDB.size === oldLength + 1)
    }

    scenario("an entry is added to the database using builders") {
      val builder = MongoDBObject.newBuilder
      builder += "foo" -> "baz"
      builder += "x" -> "z"
      builder += "pie" -> 3.14
      builder += ("spam" -> "green", "something else" -> "something cool")

      val oldLength = mongoDB.size
      mongoDB += builder.result
      assert(mongoDB.size === oldLength + 1)
    }

    scenario("an entry with a unique field is queried from the database") {
      val foundItems = mongoDB.find(MongoDBObject("x" -> "y"))
      assert(foundItems.length === 1)
    }

    scenario("multiple entries with common fields are queried from the database") {
      val foundItems = mongoDB.find(MongoDBObject("pie" -> 3.14))
      assert(foundItems.length === 2)
    }

    scenario("one entry is removed from the database") {
      val oldLength = mongoDB.size
      for (entry <- mongoDB.find(MongoDBObject("x" -> "y")))
        mongoDB -= entry
      assert(mongoDB.size === oldLength - 1)
    }

    scenario("the simple database is deleted") {
      mongoDB.dropCollection()
      assert(mongoDB.size === 0)
    }
  }
}
