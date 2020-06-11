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
class StructTest extends FunSuite {

  test("The Parser should manage the structure declaration (simple,anonymous)") {
    val input =
      """
        | struct {
        |   signed long int i;
        | };
      """.stripMargin


    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the structure declaration (simple,anonymous,declaration)") {
    val input =
      """
        | struct {
        |   signed long int i;
        | } t;
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the structure declaration (simple,anonymous,declaration) with array") {
    val input =
      """
        | struct {
        |   signed long int i;
        | } t[5];
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the structure declaration (simple)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should not manage the structure declaration (empty)") {

    val input =
      """
        | struct test {
        | };
      """.stripMargin

    intercept[Exception]{
      (new CParser).apply(input)
    }

  }

  test("The Parser should Manage the structure declaration (severals)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        |   signed long int j;
        | };
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure declaration (severals types)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        |   signed char j;
        | };
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure declaration (severals typdef)") {
    val input =
      """
        | typedef signed char T;
        |
        | struct test {
        |   signed long int i;
        |   T j;
        | };
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage (simple with use in declaration)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | struct test t;
        |
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage (simple with use in function)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |   struct test t;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage (simple with use in function args)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(struct test* t){
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should Manage the structure usage (field access)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |   struct test t;
        |   t.i = 3;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage (field use)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |  signed long int j;
        |  struct test t;
        |  j = t.i;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage (field use in addition)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |  signed long int j;
        |  signed long int z;
        |  z = 3;
        |  struct test t;
        |  j = t.i + z;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage the structure usage (with definition in array)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | struct test a;
        |
        | void f1(signed long int t){
        |  struct test b[2];
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage the structure declaration (structure imbrication)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | struct test2{
        |   struct test t;
        | };
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage indirect fieds access (field access)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |   struct test *t;
        |   t->i = 3;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage indirect fieds access (field use)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |  signed long int j;
        |  struct test *t;
        |  j = t->i;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the structure usage indirect fieds access (field use in addition)") {
    val input =
      """
        | struct test {
        |   signed long int i;
        | };
        |
        | void f1(){
        |  signed long int j;
        |  signed long int z;
        |  z = 3;
        |  struct test *t;
        |  j = t->i + z;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage structure declarator in typedef") {
    val input =
      """
        |typedef struct
        |{
        |   signed long int is_valid;
        |   signed long int dummy_1;
        |   signed long int dummy_2;
        |   signed long int dummy_3;
        |   signed long int dummy_4;
        |   signed long int dummy_5;
        |   signed long int dummy_6;
        |   signed long int dummy_7;
        |   signed long int dummy_8;
        |   signed long int crc;
        |} ParsedInputMessage_t;
        |
        |void ParseInput(ParsedInputMessage_t* tmp)
        |{
        |   ParsedInputMessage_t result;
        |   tmp->dummy_1 = 3;
        |}
        |
        |
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }
}
