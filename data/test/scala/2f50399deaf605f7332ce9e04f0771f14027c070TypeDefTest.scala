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
class TypeDefTest extends FunSuite {


  test("The Parser should Manage the typedef operator global") {
    val input =
      """
        |typedef signed long int mytype;
      """.stripMargin


    val unit = (new CParser).apply(input)
    TestUtils.compare(input,unit.toString)
  }

  test("The Parser should Manage the typedef operator in function") {
    val input =
      """
        |typedef signed long int mytype;
        |
        |  void f1 (mytype *res){
        |    mytype i;
        |    mytype j;
        |    mytype z;
        |    i = 0;
        |    j = 5;
        |    z = i == j;
        |    (*res)=z;
        |  }
      """.stripMargin

    val unit = (new CParser).apply(input)
    utils.TestUtils.compare(input,unit.toString)
  }


}