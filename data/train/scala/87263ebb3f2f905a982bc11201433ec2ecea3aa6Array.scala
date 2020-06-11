package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite
import be.cetic.ratchet.reader.combinators.CParser
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.{ParserTestSuite, TestUtils}

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class Array extends ParserTestSuite {

  "The Parser" should "manage simple array declaration" in {
    val input =
      """
        |signed long int i[6];
      """.stripMargin


    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }

  it should "manage array declaration without size specifier" in {
    val input =
      """
        |signed long int i[];
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  it should "manage 2-D array declaration" in {
    val input =
      """
        |signed long int i[3][6];
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  it should "manage 5-D array declaration" in {
    val input =
      """
        |signed long int i[3][6][6][6][6];
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  it should "manage 1-D array declaration with pointer" in {
    val input =
      """
        |signed long int* i[3];
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  it should "manage 1-D array declaration in function scope" in {
    val input =
      """
        |void f1(){
        | signed long int i[6];
        |}
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  it should "manage 5 1-D array declaration in function scope" in {
    val input =
      """
        |void f1(){
        | signed long int i1[6];
        | signed long int i2[6];
        | signed long int i3[6];
        | signed long int i4[6];
        | signed long int i5[6];
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  it should "manage simple array affectation" in {
    val input =
      """
        |void f1(){
        | signed long int i[6];
        | i[0] = 12;
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  it should "manage array affectation from array" in {
    val input =
      """
        |void f1(){
        | signed long int i[6];
        | signed long int j[6];
        | i[0] = j[0];
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

}
