/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.zend

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class XorSpec extends SpecificationWithJUnit with TestJbjExecutor {
  "Xor" should {
    "XORing arrays" in {
      // ../php-src/Zend/tests/xor_001.phpt
      script(
        """<?php
          |
          |$a = array(1,2,3);
          |$b = array();
          |
          |$c = $a ^ $b;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(1)
          |Done
          |""".stripMargin
      )
    }

    "XORing strings" in {
      // ../php-src/Zend/tests/xor_002.phpt
      script(
        """<?php
          |
          |$s = "123";
          |$s1 = "234";
          |var_dump(bin2hex($s ^ $s1));
          |
          |$s = "1235";
          |$s1 = "234";
          |var_dump(bin2hex($s ^ $s1));
          |
          |$s = "some";
          |$s1 = "test";
          |var_dump(bin2hex($s ^ $s1));
          |
          |$s = "some long";
          |$s1 = "test";
          |var_dump(bin2hex($s ^ $s1));
          |
          |$s = "some";
          |$s1 = "test long";
          |var_dump(bin2hex($s ^ $s1));
          |
          |$s = "some";
          |$s ^= "test long";
          |var_dump(bin2hex($s));
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """string(6) "030107"
          |string(6) "030107"
          |string(8) "070a1e11"
          |string(8) "070a1e11"
          |string(8) "070a1e11"
          |string(8) "070a1e11"
          |Done
          |""".stripMargin
      )
    }

    "XORing booleans" in {
      // ../php-src/Zend/tests/xor_003.phpt
      script(
        """<?php
          |
          |$t = true;
          |$f = false;
          |
          |var_dump($t ^ $f);
          |var_dump($t ^ $t);
          |var_dump($f ^ $f);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(1)
          |int(0)
          |int(0)
          |Done
          |""".stripMargin
      )
    }
  }
}
