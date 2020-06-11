package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite
import be.cetic.ratchet.reader.ast.{TranslationUnit, While}
import be.cetic.ratchet.reader.combinators.CParser
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.TestUtils

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class ForStatement extends FunSuite {

  def forstmt(tu:TranslationUnit) = tu.descendantsOfType[While]().head

  test("The Parser should manage empty for statement with constant as condition") {
    val input =
      """
        | void f(){
        |   for(;1;){
        |
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage empty for statement without curly braces") {
    val input =
      """
        | void f(){
        |   for(signed long int a;a;a=a+1) a=a+1;
        |   a=a+1;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage empty for statement with variable as condition") {
    val input =
      """
        | void f(){
        |   for(signed long int a;a;a=a+1){
        |
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage for statement with one statement") {
    val input =
      """
        | void f(){
        |   for(signed long int a=0;1;a=a-1){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage for statement with function args in statement") {
    val input =
      """
        | void f(signed long int b){
        |   for(signed long int a;1;a=a+1){
        |     a = a + b;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage for statement with one break statement") {
    val input =
      """
        | void f(){
        |   for(signed long int a;1;a=a+1){
        |     if(a>6){
        |       break;
        |     }
        |   }
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage for statement with one continue statement") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   for(;1;){
        |     if(a>6){
        |       continue;
        |     }
        |   }
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage for statement with expression as condition") {
    val input =
      """
        | void f(signed long int b){
        |   for(signed long int a=0;a < b; a = a+1){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage for statement with pointer in condition") {
    val input =
      """
        | void f(signed long int* b){
        |   signed long int a;
        |   for(a=0;a >= (*b);){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage function call in condition") {
    val input =
      """
        |
        | void cond(signed long int a){
        |   return a == 0;
        | }
        | void f(signed long int* b){
        |   signed long int a;
        |   for(a=b+1;cond(a);){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage mixed expression in condition") {
    val input =
      """
        |
        | signed long int cond(signed long int a){
        |   return a == 0;
        | }
        | void f(signed long int* b){
        |   signed long int a;
        |   for(a=*b;cond(a) && ((*b)<=0);){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


}
