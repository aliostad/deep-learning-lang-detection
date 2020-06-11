package com.gray.logic.language

import com.gray.logic.formula.{Constant, Relation, Sentence}
import com.gray.logic.formula._
import org.scalatest.{FlatSpec, Matchers}

class FormulaWriterAlphabeticSpec extends FlatSpec with Matchers {

  val writer = FormulaWriterAlphabetic

  "write" should "write a sentence" in {
    writer(Sentence(0)) shouldBe "A"
    writer(Sentence(1)) shouldBe "B"
    writer(Sentence(5)) shouldBe "F"
    writer(Sentence(25)) shouldBe "Z"
  }

  it should "write a Relation" in {
    writer(Relation(0, Seq(Constant(0)))) shouldBe "Ra"
    writer(Relation(8, Seq(Constant(0)))) shouldBe "Za"
    writer(Relation(9, Seq(Constant(0)))) shouldBe "Qa"
    writer(Relation(25, Seq(Constant(0)))) shouldBe "Aa"
  }

  it should "write a Constant" in {
    writer.writeConstant(0) shouldBe "a"
    writer.writeConstant(11) shouldBe "l"
  }

  it should "write a Variable" in {
    writer.writeVariable(0) shouldBe "v"
    writer.writeVariable(4) shouldBe "z"
    writer.writeVariable(5) shouldBe "u"
    writer.writeVariable(13) shouldBe "m"
  }

  it should "write a Function" in {
    writer.writeFunction(0, Seq("a")) shouldBe "f(a)"
    writer.writeFunction(1, Seq("a")) shouldBe "g(a)"
    writer.writeFunction(10, Seq("a")) shouldBe "p(a)"
  }

}
