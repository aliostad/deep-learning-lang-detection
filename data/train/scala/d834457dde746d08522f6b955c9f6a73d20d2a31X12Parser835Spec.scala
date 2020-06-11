package com.andrewjamesjohnson.x12.parser

import com.andrewjamesjohnson.x12.config.reader.JsonConfigReader
import org.json4s.jackson.JsonMethods._
import org.specs2.mutable.Specification

import scala.io.Source

class X12Parser835Spec extends Specification {
  "X12Parser835" should {
    "decode an X12 file according to a given configuration" in {
      val config = JsonConfigReader.read(getClass.getResource("/example835.json"))
      val document = X12Parser.parse(getClass.getResource("/example835.x12"), config)
      val input = Source.fromURL(getClass.getResource("/example835.x12")).mkString
      document.debug()

      println(pretty(document.toJson))

      //      println(pretty(document.toOldJson))

      //      println(pretty(document.toOldOldJson))

      input mustEqual document.toString()
    }
  }
}
