package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import be.cetic.ratchet.reader.ast._
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import be.cetic.ratchet.reader.helpers.ASTException
import be.cetic.ratchet.reader.combinators.CParser
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.{ParserFixtureGenerator, ParserTestSuite, TestUtils}

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class GotoTest extends ParserTestSuite with ParserFixtureGenerator {


  def checkGoto(unit: AstNode) {
    val gotos = unit.descendantsOfType[Goto]()
    assert(gotos.size equals 1)
    val goto = gotos.head
    val labels = unit.descendantsOfType[LabelledStmt]()
    assert(labels.size equals 1)
    val label = labels.head
    assert(goto.label equals "test")
    assert(goto.target equals label)
  }

  it should "Manage goto operator with label declared before" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  test:
        |  a = b + 1;
        |  goto test;
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    TestUtils.compare(pattern, unit.toString)
    checkGoto(unit)
  }

  it should "Manage goto operator with label declared after" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  goto test;
        |  test:
        |  a = b + 1;
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
    checkGoto(unit)
  }

  it should "Manage goto operator with 2 labels" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  test1: goto test2;
        |  test2: goto test1;
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
    val gotos = unit.descendantsOfType[Goto]()
    assert(gotos.size equals 2)
    val goto2 = gotos(0)
    val goto1 = gotos(1)
    val labels = unit.descendantsOfType[LabelledStmt]()
    assert(labels.size equals 2)
    val label1 = labels(0)
    val label2 = labels(1)
    assert(goto1.label equals "test1")
    assert(goto2.label equals "test2")
    assert(goto1.target equals label1)
    assert(goto2.target equals label2)
  }



  it should "manage error when 2 same labels are declared in same scope" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  test :
        |  a = a + 1;
        |  test :
        |  b = b + 1;
        |}
      """.stripMargin
    intercept[ASTException]{
      (new CParser).apply(pattern)
    }
  }

  it should "Manage goto operator with 2 same labels in different scope" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  goto test;
        |  test :
        |  b = a + 1;
        |}
        |
        |void  f2 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  goto test;
        |  test :
        |  b = a + 1;
        |}
        |
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
    val fun1 = unit.descendantsOfType[FunDef]().filter(f => f.name equals "f1").head
    val fun2 = unit.descendantsOfType[FunDef]().filter(f => f.name equals "f2").head
    checkGoto(fun1)
    checkGoto(fun2)
  }

  it should "throw an error if goto operator point on a label in a different scope" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        |  signed long int a;
        |  signed long int b;
        |  test :
        |  b = a + 1;
        |}
        |
        |void  f2 (signed long int *res)
        |{
        |  goto test;
        |}
        |
      """.stripMargin
    intercept[ASTException]{
      (new CParser).apply(pattern)
    }
  }

  it should "Manage goto operator with label declared in 2 differents blocks" in {
    val pattern =
      """
        |void  f1 (signed long int *res)
        |{
        | signed long int a;
        | signed long int b;
        | if (1) {
        |   goto test;
        | }
        | else {
        |   test:
        |   a=b+1;
        | }
        |}
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
    checkGoto(unit)
  }
}
