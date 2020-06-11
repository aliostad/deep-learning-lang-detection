package com.fdilke.scala

import org.scalatest.FunSpec
import play.api.libs.json.{Json, Reads, Writes}
import org.scalatest.Matchers._

// Illustrates both pretty-printing values from a dummy domain model, and
// verifying that they give equivalent results to Play's Json serialization.

class JsonConversionTest extends FunSpec {
  case class JoinerField(
   fieldName: String,
   propertyChain: Seq[String]
 ) {
    override def toString: String =
      s"""
         |  {
         |    "fieldName": "$fieldName",
         |    "propertyChain": [
         |      ${
        propertyChain map {
          "\"" + _ + "\""
        } mkString ",\n"
      }
         |    ]
         |  }
     """.stripMargin
  }

  object JoinerField {
    implicit val userReads: Reads[JoinerField] =
      Json.reads[JoinerField]
    implicit val userWrites: Writes[JoinerField] =
      Json.writes[JoinerField]
  }

  case class JoinerSpec(
    transitNode: String,
    transitCluster: String,
    transitClusterSniff: Boolean,
    bulkUpdateBatchSize: Int,
    manageIndex: Boolean,
    manageMapping: Boolean,
    types: Seq[String],
    fields: Seq[JoinerField]
  ) {
    override def toString: String =
      s"""
         |{
         |  "transitNode": "$transitNode",
         |  "transitCluster": "$transitCluster",
         |  "transitClusterSniff": $transitClusterSniff,
         |  "bulkUpdateBatchSize": $bulkUpdateBatchSize,
         |  "manageIndex": $manageIndex,
         |  "manageMapping": $manageMapping,
         |  "types": [
         |  ${
        types map {
          "  \"" + _ + "\""
        } mkString ",\n"
      }
         | ],
         |  "fields": [
         |  ${
        fields map {
          _.toString
        } mkString ",\n"
      }
         | ]
         |}
     """.stripMargin
  }

  object JoinerSpec {
    implicit val userReads: Reads[JoinerSpec] =
      Json.reads[JoinerSpec]
    implicit val userWrites: Writes[JoinerSpec] =
      Json.writes[JoinerSpec]
  }

  describe("The connector config") {
    it("is encoded properly as a string") {

      val joinerSpec = JoinerSpec(
        "TRANSIT_HOST:9300",
        "TRANSIT_CLUSTER_NAME",
        true,
        10000,
        false,
        false,
        Seq(
          "http://www.example.com/Item"
        ),
        Seq(
          JoinerField(
            "nodeId",
            Seq(
              "http://www.example.com/Property"
            )
          )
        )
      )

      Json.parse(
        s"""
           |{
           |  "transitNode": "TRANSIT_HOST:9300",
           |  "transitCluster": "TRANSIT_CLUSTER_NAME",
           |  "transitClusterSniff": true,
           |  "bulkUpdateBatchSize": 10000,
           |  "manageIndex": false,
           |  "manageMapping": false,
           |  "types": [
           |    "http://www.example.com/Item"
           |  ],
           |  "fields": [
           |      {
           |      "fieldName": "nodeId",
           |      "propertyChain": [
           |        "http://www.example.com/Property"
           |      ]
           |    }
           |  ]
           |}
         """.stripMargin
      ).as[
        JoinerSpec
      ] shouldBe joinerSpec

      Json.parse(
        joinerSpec.toString
      ).as[
        JoinerSpec
      ] shouldBe joinerSpec
    }
  }
}

