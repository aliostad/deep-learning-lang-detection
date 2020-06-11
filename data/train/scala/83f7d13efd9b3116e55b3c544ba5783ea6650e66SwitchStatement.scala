package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite
import be.cetic.ratchet.reader.ast.{SwitchCase, TranslationUnit}
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.TestUtils

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class SwitchStatement extends FunSuite {

  def switch(tu:TranslationUnit) = tu.descendantsOfType[SwitchCase]().head

  test("The Parser should manage empty switch statement") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 0)
  }


  test("The Parser should manage switch statement with only default") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |     default: a=3;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 1)
  }

  test("The Parser should manage switch statement with only one case") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |     case 1: a=3;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 1)
  }

  test("The Parser should manage switch statement with only one case with break") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |     case 1: a=3;break;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 1)
  }


  test("The Parser should manage switch statement with only one case with default") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |     case 1: a = 3;
        |     default: a = 5;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 2)
  }


  test("The Parser should manage switch statement with only one case with default with break") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |     case 1: a=3;break;
        |     default: a = 5;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 2)
  }


  test("The Parser should manage switch statement with only one case with multiple case with break") {
    val input =
      """
        | void f(){
        |   signed long int a;
        |   a = 0;
        |
        |   switch(a){
        |     case 1: a=3;break;
        |     case 2: a=4;break;
        |     case 3: a=7;break;
        |     default: a = 5;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 4)
  }

  test("The Parser should manage switch statement with only one case with multiple case with break with enum") {
    val input =
      """
        | enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        | void f(){
        |   signed long int a;
        |   enum jour j;
        |
        |   switch(j){
        |     case LUNDI: a=3;break;
        |     case MARDI: a=4;break;
        |     case MERCREDI: a=7;break;
        |     case JEUDI: a=7;break;
        |     case VENDREDI: a=7;break;
        |     default: a = 5;
        |   }
        | }
      """.stripMargin


    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
    assert(switch(unit)!=null)
    assert(switch(unit).labels.size == 6)
  }

}
