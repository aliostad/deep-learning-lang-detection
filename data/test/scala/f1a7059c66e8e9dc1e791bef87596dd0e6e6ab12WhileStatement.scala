package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite
import be.cetic.ratchet.reader.ast.{SwitchCase, TranslationUnit, While}
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.TestUtils

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class WhileStatement extends FunSuite {

  def whilestmt(tu:TranslationUnit) = tu.descendantsOfType[While]().head

  test("The Parser should manage empty while statement with constant as condition") {
    val input =
      """
        | void f(){
        |   while(1){
        |
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage empty while statement without curly braces") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   while(a) a=a+1;
        |   a=a+1;
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage empty while statement with variable as condition") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   while(a){
        |
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage while statement with one statement") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   while(1){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage while statement with function args in statement") {
    val input =
      """
        | void f(signed long int b){
        |   signed long int a;
        |   while(1){
        |     a = a + b;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage while statement with one break statement") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   while(1){
        |     if(a>6){
        |       break;
        |     }
        |   }
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage while statement with one continue statement") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   while(1){
        |     if(a>6){
        |       continue;
        |     }
        |   }
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage while statement with expression as condition") {
    val input =
      """
        | void f(signed long int b){
        |   signed long int a;
        |   while(a < b){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage while statement with pointer in condition") {
    val input =
      """
        | void f(signed long int* b){
        |   signed long int a;
        |   while(a >= (*b)){
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
        | signed long int cond(signed long int a){
        |   return a == 0;
        | }
        | void f(signed long int* b){
        |   signed long int a;
        |   while(cond(a)){
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
        |   while(cond(a) && ((*b)<=0)){
        |     a = a + 1;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage empty dowhile statement with constant as condition") {
    val input =
      """
        | void f(){
        |   do {
        |
        |   }while(1);
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage empty dowhile statement with variable as condition") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   do{
        |
        |   }while(a);
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage empty dowhile statement without curly braces") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   do a=a+1; while(a);
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage dowhile statement with one statement") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   do {
        |     a = a + 1;
        |   }while(1);
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage dowhile statement with function args in statement") {
    val input =
      """
        | void f(signed long int b){
        |   signed long int a;
        |   do{
        |     a = a + b;
        |   }while(1);
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage dowhile statement with expression as condition") {
    val input =
      """
        | void f(signed long int b){
        |   signed long int a;
        |   do {
        |     a = a + 1;
        |   }while(a < b);
        | }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


  test("The Parser should manage dowhile statement with pointer in condition") {
    val input =
      """
        | void f(signed long int* b){
        |   signed long int a;
        |   do {
        |     a = a + 1;
        |   } while(a >= (*b));
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage function call in condition dowhile") {
    val input =
      """
        |
        | void cond(signed long int a){
        |   return a == 0;
        | }
        | void f(signed long int* b){
        |   signed long int a;
        |   do{
        |     a = a + 1;
        |   }while(cond(a));
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

  test("The Parser should manage mixed expression in condition dowhile") {
    val input =
      """
        |
        | signed long int cond(signed long int a){
        |   return a == 0;
        | }
        | void f(signed long int* b){
        |   signed long int a;
        |   do{
        |     a = a + 1;
        |   }while(cond(a) && ((*b)<=0));
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }

}
