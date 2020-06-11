/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.zend

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class ShiftSpec extends SpecificationWithJUnit with TestJbjExecutor {
  "Bit shift" should {
    "shifting strings left" in {
      // ../php-src/Zend/tests/shift_001.phpt
      script(
        """<?php
          |
          |$s = "123";
          |$s1 = "test";
          |$s2 = "45345some";
          |
          |$s <<= 2;
          |var_dump($s);
          |
          |$s1 <<= 1;
          |var_dump($s1);
          |
          |$s2 <<= 3;
          |var_dump($s2);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(492)
          |int(0)
          |int(362760)
          |Done
          |""".stripMargin
      )
    }

    "shifting strings right" in {
      // ../php-src/Zend/tests/shift_002.phpt
      script(
        """<?php
          |
          |$s = "123";
          |$s1 = "test";
          |$s2 = "45345some";
          |
          |$s >>= 2;
          |var_dump($s);
          |
          |$s1 >>= 1;
          |var_dump($s1);
          |
          |$s2 >>= 3;
          |var_dump($s2);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(30)
          |int(0)
          |int(5668)
          |Done
          |""".stripMargin
      )
    }
  }
}
