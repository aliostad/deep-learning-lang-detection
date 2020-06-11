package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import be.cetic.ratchet.reader.ast._
import be.cetic.ratchet.reader.ast.LogicalOr
import be.cetic.ratchet.reader.ast.BitAnd
import be.cetic.ratchet.reader.ast.BitOr
import be.cetic.ratchet.utils.{ParserFixtureGenerator, ParserTestSuite}

/**
  *
  * @author : dimitri durieux <dimitri.durieux@cetic.be>
  */
@RunWith(classOf[JUnitRunner])
class LogicalOperators extends ParserTestSuite with ParserFixtureGenerator {

  "The Parser" should "Manage and operator" in {
    testRelBinOp[LogicalAnd](genRelBinOpFun("&&"),signed = true)
  }

  "The Parser" should "Manage or operator" in {
    testRelBinOp[LogicalOr](genRelBinOpFun("||"),signed = true)
  }

  "The Parser" should "Manage negation operator" in {
    testUnOp[Not](genUnOpFun("!"),IntType(32,signed = true))
  }

  "The Parser" should "Manage bit wise and operator" in {
    testBinOp[BitAnd](genBinOpFun("&"),signed = true)
  }

  "The Parser" should "Manage bit wise or operator" in {
    testBinOp[BitOr](genBinOpFun("|"),signed = true)
  }

  "The Parser" should "Manage bit wise not operator" in {
    testUnOp[BitNot](genUnOpFun("~"),IntType(32,signed = true))
  }
 }
