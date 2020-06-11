package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import be.cetic.ratchet.reader.ast.{Constant, IntType}
import be.cetic.ratchet.utils
import be.cetic.ratchet.utils.{ParserFixtureGenerator, ParserTestSuite, TestUtils}

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class OctalandHexadecimal extends ParserTestSuite with ParserFixtureGenerator {

  "The Parser" should "Manage octal literal" in {
    val pattern =
      """
        |signed long int a = 010;
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    TestUtils.compare(pattern, unit.toString)
    val constants = unit.descendantsOfType[Constant]()
    assert(constants.size equals 1)
    val constant = constants.head
    assert(constant.asLong equals 8L)
    assert(constant.parserString equals "010")
    assert(constant.constType equals IntType(32,true))
  }

  it should "Manage hexadecimal literal" in {
    val pattern =
      """
        |signed long int a = 0x10;
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
    val constants = unit.descendantsOfType[Constant]()
    assert(constants.size equals 1)
    val constant = constants.head
    assert(constant.asLong equals 16L)
    assert(constant.parserString equals "0x10")
    assert(constant.constType equals IntType(32,true))
  }


  it should "Manage hexadecimal literal FFFFFFFF" in {
    val pattern =
      """
        |signed long int a = 0xFFFFFFFF;
      """.stripMargin
    val unit = (new CParser).apply(pattern)
    utils.TestUtils.compare(pattern, unit.toString)
    val constants = unit.descendantsOfType[Constant]()
    assert(constants.size equals 1)
    val constant = constants.head

    assert(constant.asLong equals (1L<<32)-1)
    assert(constant.parserString equals "0xFFFFFFFF")
    assert(constant.constType equals IntType(32,true))
  }



}
