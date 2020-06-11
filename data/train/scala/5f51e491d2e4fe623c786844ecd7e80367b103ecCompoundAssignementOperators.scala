package be.cetic.ratchet.reader.combinators

/* This Source Code Form is subject to the terms of the Mozilla Public
 * License, v. 2.0. If a copy of the MPL was not distributed with this
 * file, You can obtain one at http://mozilla.org/MPL/2.0/. */

import org.junit.runner.RunWith
import org.scalatest.junit.JUnitRunner
import be.cetic.ratchet.reader.ast._
import be.cetic.ratchet.utils.{ParserFixtureGenerator, ParserTestSuite}

/**
 *
 * @author : dimitri durieux <dimitri.durieux@cetic.be>
 */
@RunWith(classOf[JUnitRunner])
class CompoundAssignementOperators extends ParserTestSuite
  with ParserFixtureGenerator {


  "The parser" should "manage += operator" in {
    testAssignationOp[CompoundPlus](genAssignOpFun("+="))
  }

  it should "manage *= operator" in {
    testAssignationOp[CompoundTimes](genAssignOpFun("*="))
  }

  it should "manage /= operator" in {
    testAssignationOp[CompoundDiv](genAssignOpFun("/="))
  }

  it should "manage %= operator" in {
    testAssignationOp[CompoundMod](genAssignOpFun("%="))
  }

  it should "manage -= operator" in {
    testAssignationOp[CompoundMinus](genAssignOpFun("-="))
  }

  it should "manage <<= operator" in {
    testAssignationOp[CompoundShiftLeft](genAssignOpFun("<<="))
  }

  it should "manage >>= operator" in {
    testAssignationOp[CompoundShiftRight](genAssignOpFun(">>="))
  }

  it should "manage &= operator" in {
    testAssignationOp[CompoundAnd](genAssignOpFun("&="))
  }

  it should "manage ^= operator" in {
    testAssignationOp[CompoundXor](genAssignOpFun("^="))
  }

  it should "manage |= operator" in {
    testAssignationOp[CompoundOr](genAssignOpFun("|="))
  }
}
