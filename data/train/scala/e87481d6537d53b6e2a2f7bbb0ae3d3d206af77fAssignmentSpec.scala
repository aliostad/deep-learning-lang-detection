/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.special

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class AssignmentSpec extends SpecificationWithJUnit with TestJbjExecutor{
  "Assignment" should {
    "list assignment" in {
      script(
        """<?php
          |list($a, $b) = array(1, 2);
          |
          |var_dump($a, $b);
          |
          |list($c, $d) = array(1 => 3, 0 => 4);
          |
          |var_dump($c, $d);
          |
          |list($a, $b) = array(100 => 1, 200 => 2);
          |
          |var_dump($a, $b);
          |?>""".stripMargin
      ).result must haveOutput(
        """int(1)
          |int(2)
          |int(4)
          |int(3)
          |
          |Notice: Undefined offset: 1 in /special/AssignmentSpec.inlinePhp on line 10
          |
          |Notice: Undefined offset: 0 in /special/AssignmentSpec.inlinePhp on line 10
          |NULL
          |NULL
          |""".stripMargin
      )
    }
  }

}
