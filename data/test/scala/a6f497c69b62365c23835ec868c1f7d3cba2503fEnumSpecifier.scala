package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import org.scalatest.FunSuite
import be.cetic.ratchet.reader.combinators.CParser
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.TestUtils

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class EnumSpecifier extends FunSuite {

  test("The Parser should manage enum declaration") {
    val pattern =
      """
        |enum {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage enum declaration with constant") {
    val pattern =
      """
        |enum {LUNDI = 10, MARDI = 11, MERCREDI = 22, JEUDI, VENDREDI, SAMEDI, DIMANCHE = 30};
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage enum declaration with label") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage variable declaration of type enum inline") {
    val pattern =
      """
        |enum {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE} j1;
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }


  test("The Parser should manage variable declaration of type enum inline with affectation") {
    val pattern =
      """
        |void f(){
        | enum {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE} j1;
        | j1 = LUNDI;
        |}
        |
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage variable declaration of type enum") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |enum jour j1;
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage variable declaration of type enum without enum keyword") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |jour j1;
      """.stripMargin

    val expected =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |enum jour j1;
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(expected, unit.toString)
  }

  test("The Parser should manage variable declaration of type enum in function") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |void f(enum jour j1, enum jour j2){
        |
        |}
        |
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage usage of variable of type enum in function") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |void f(enum jour j1, enum jour j2){
        | j1 = LUNDI;
        |}
        |
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage comparaison of variable of type enum in function") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |void f(enum jour j1, enum jour j2){
        | if(j2 == MARDI){
        |   j1= MERCREDI;
        | }
        |}
        |
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }

  test("The Parser should manage comparaison of variable of type enum in function without label") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |void f(jour j1, jour j2){
        | if(j2 == MARDI){
        |   j1= MERCREDI;
        | }
        |}
        |
      """.stripMargin


    val expected =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |void f(enum jour j1, enum jour j2){
        | if(j2 == MARDI){
        |   j1= MERCREDI;
        | }
        |}
        |
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(expected, unit.toString)
  }

  test("The Parser should manage call of function with enum element has params") {
    val pattern =
      """
        |enum jour {LUNDI, MARDI, MERCREDI, JEUDI, VENDREDI, SAMEDI, DIMANCHE};
        |
        |void f(enum jour j1, enum jour j2){
        |
        |}
        |
        |void f2(){
        | f(LUNDI,MARDI);
        |}
      """.stripMargin

    val lines = pattern
    val unit = (new CParser).apply(lines)
    utils.TestUtils.compare(lines, unit.toString)
  }
}
