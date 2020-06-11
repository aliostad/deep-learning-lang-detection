package dynamo.ast.writes

import cats.implicits._
import dynamo.ast.{M, S}
import org.specs2.Specification

class DynamoWriteTest extends Specification { def is = s2"""
  Tests for DynamoWrite
    writing to a valid path should yield an M with the corresponding type $write
    writing to a valid path an Option should yield an M with the corresponding type $writeOptPresent
    writing to a valid path an empty Option should yield an empty M $writeOptAbsent
    the product of two writers should yield a M with two fields $writeProduct
    the product of two writers writing the same location should yield a M with one field erased by the latest value $writeProductErase
"""

  def write = {
    DynamoWrite.write[String].at("test").write("test_string") should_== M(List("test" -> S("test_string")))
  }

  def writeOptPresent = {
    DynamoWrite.writeOpt[String].at("test").write(Some("test_string")) should_== M(List("test" -> S("test_string")))
  }

  def writeOptAbsent = {
    DynamoWrite.writeOpt[String].at("test").write(None) should_== M(List())
  }

  def writeProduct = {
    val writer: DynamoWrite[(String, String)] =
    (DynamoWrite.write[String].at("field1")
        |@| DynamoWrite.write[String].at("field2")).contramap[(String, String)](z => (z._1, z._2))

    writer.write(("value1", "value2")) should_== M(List("field1" -> S("value1"), "field2" -> S("value2")))
  }

  def writeProductErase = {
    val writer: DynamoWrite[(String, String)] =
      (DynamoWrite.write[String].at("field1")
          |@| DynamoWrite.write[String].at("field1")).contramap[(String, String)](z => (z._1, z._2))

    writer.write(("value1", "value2")) should_== M(List("field1" -> S("value2")))
  }
}
