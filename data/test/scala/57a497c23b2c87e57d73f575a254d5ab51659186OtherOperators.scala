package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.TestUtils
import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite

/**
  *
  * @author : dimitri durieux <dimitri.durieux@cetic.be>
  */
@RunWith(classOf[JUnitRunner])
class OtherOperators extends FunSuite {

  test("The Parser should manage the sizeof operator with variable without parenthesis") {
    val input =
      """
        |void f1 (signed long int* res){
        | signed long int i;
        | signed long int j;
        | signed long int z;
        | i = sizeof(z);
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the sizeof operator with variable") {
    val input =
      """
        |void f1 (signed long int* res){
        | signed long int i;
        | signed long int j;
        | signed long int z;
        | i = sizeof z;
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the sizeof operator with type") {
    val input =
      """
        |void f1 (signed long int* res){
        | signed long int i;
        | signed long int j;
        | signed long int z;
        | i = sizeof(signed long int);
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the variable declaration with initialization (int)") {
    val input =
      """
        |void f1 (signed long int* res){
        | signed long int i = 0;
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the variable declaration with initialization (char)") {
    val input =
      """
        |void f1 (signed long int* res){
        | signed char i = 'a';
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the variable declaration with initialization (typedef)") {
    val input =
      """
        |typedef signed long int INT32;
        |void f1 (signed long int* res){
        | INT32 i = 12;
        |}
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

 }
