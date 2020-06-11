package io.github.alexeygrishin.pal.functions

import org.scalatest.FunSpec
import scala.collection.JavaConversions._
import io.github.alexeygrishin.pal.tools.Tool

class FunctionImplementationJsonTest extends FunSpec {

  val json = Data.palImplementationJson

  def loadJson(json: String) = Tool.readFunction(json)

  describe("loading json with FunctionJson class") {

    it("shall not throw error") {
      loadJson(json)
    }

    it("shall load function name") {
      expectResult("sum") { loadJson(json).name }
    }

    it("shall load function description") {
      expectResult("Test") { loadJson(json).interface.description }
      assert(Array("sum", "math") === loadJson(json).interface.tags)
    }

    it("shall load function signature") {
      val loaded = loadJson(json)
      assert("int" === loaded.interface.rettype)
      val map = Map("a1" -> "int", "a2" -> "int")
      assert(map === loaded.interface.args.toMap)
    }

    it("shall load function body") {
      val loaded = loadJson(json)
      assert(1 == loaded.implementation.get("pal").size())
    }


  }
}
