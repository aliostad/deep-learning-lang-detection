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
class RelationalOperator extends ParserTestSuite with ParserFixtureGenerator {

  "The Parser" should " manage equality operator" in {
    testRelBinOp[Equ](genRelBinOpFun("=="),true)
  }

  it should " manage inequality operator" in {
    testRelBinOp[Nequ](genRelBinOpFun("!="),true)
  }

  it should " manage greater operator" in {
    testRelBinOp[G](genRelBinOpFun(">"),true)
  }

  it should " manage lesser operator" in {
    testRelBinOp[L](genRelBinOpFun("<"),true)
  }

  it should " manage greater or equal operator" in {
    testRelBinOp[Ge](genRelBinOpFun(">="),true)
  }

  it should " manage lesser or equal operator" in {
    testRelBinOp[Le](genRelBinOpFun("<="),true)
  }
}
