package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite
import be.cetic.ratchet.reader.ast.{Div, Minus, Plus, Times}
import be.cetic.ratchet.reader.combinators.CParser
import be.cetic.ratchet.utils.{ParserFixtureGenerator, ParserTestSuite, TestUtils}

/**
  *
  * @author : dimitri durieux <dimitri.durieux@cetic.be>
  */
@RunWith(classOf[JUnitRunner])
class ArithmeticOperators extends ParserTestSuite with ParserFixtureGenerator {

  "The parser" should "Manage the addition operator" in {
    testBinOp[Plus](genBinOpFun("+"),true)
  }

  it should "Manage the addition operator (parsing error from chain2)" in {
    val input =
      """
        |  typedef signed long int INT8;
        |  typedef unsigned long int UINT32;
        |  typedef signed long int INT32;
        |
        |  void test_addition(INT8 a, INT8 b, INT8 *result)
        |  {
        |    *result = a + b;
        |  }
      """.stripMargin
    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }


  it should "Manage the subtraction operator" in {
    testBinOp[Minus](genBinOpFun("-"),true)
  }

  it should "Manage the product operator" in {
    testBinOp[Times](genBinOpFun("*"),true)
  }

  it should "Manage the division operator" in {
    testBinOp[Div](genBinOpFun("/"),true)
  }
 }
