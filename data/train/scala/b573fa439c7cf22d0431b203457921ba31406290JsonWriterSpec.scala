package preso.typeclass.expr

import org.scalatest.{Matchers, path}
import preso.typeclass.expr.JsonWriter.wrap

class JsonWriterSpec extends path.FunSpec with Matchers {

  describe("JsonWriter write") {

    it("Should write Null") {
      JsonWriter.write(JsonNull) shouldBe wrap("null")
    }

    it("should write Boolean") {
      JsonWriter.write(JsonBoolean(true)) shouldBe wrap("true")
      JsonWriter.write(JsonBoolean(false)) shouldBe wrap("false")
    }

    it("Should write JsonNumber") {
      JsonWriter.write(JsonNumber(10)) shouldBe "10"
    }

    it("Should write JsonStrings") {
      JsonWriter.write(JsonString("Hello")) shouldBe wrap("Hello")
    }

    it("Should write Object") {
      val pair = ("key", JsonNull)
      JsonWriter.write(JsonObject(pair)) shouldBe  """{"key": "null"}"""
    }

    it("should write Array") {
      JsonWriter.write(JsonArray(JsonNumber(12), JsonNumber(3))) shouldBe """[12, 3]"""
    }
  }
}