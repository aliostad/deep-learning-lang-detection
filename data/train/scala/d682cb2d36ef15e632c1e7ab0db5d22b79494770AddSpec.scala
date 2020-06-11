/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.zend

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class AddSpec extends SpecificationWithJUnit with TestJbjExecutor {
  "Arithmetic add" should {
    "adding arrays" in {
      // ../php-src/Zend/tests/add_001.phpt
      script(
        """<?php
          |
          |$a = array(1,2,3);
          |$b = array("str", "here");
          |
          |$c = $a + $b;
          |var_dump($c);
          |
          |$a = array(1,2,3);
          |$b = array(1,2,4);
          |
          |$c = $a + $b;
          |var_dump($c);
          |
          |$a = array("a"=>"aaa",2,3);
          |$b = array(1,2,"a"=>"bbbbbb");
          |
          |$c = $a + $b;
          |var_dump($c);
          |
          |$a += $b;
          |var_dump($c);
          |
          |$a += $a;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """array(3) {
          |  [0]=>
          |  int(1)
          |  [1]=>
          |  int(2)
          |  [2]=>
          |  int(3)
          |}
          |array(3) {
          |  [0]=>
          |  int(1)
          |  [1]=>
          |  int(2)
          |  [2]=>
          |  int(3)
          |}
          |array(3) {
          |  ["a"]=>
          |  string(3) "aaa"
          |  [0]=>
          |  int(2)
          |  [1]=>
          |  int(3)
          |}
          |array(3) {
          |  ["a"]=>
          |  string(3) "aaa"
          |  [0]=>
          |  int(2)
          |  [1]=>
          |  int(3)
          |}
          |array(3) {
          |  ["a"]=>
          |  string(3) "aaa"
          |  [0]=>
          |  int(2)
          |  [1]=>
          |  int(3)
          |}
          |Done
          |""".stripMargin
      )
    }

    "adding objects to arrays" in {
      // ../php-src/Zend/tests/add_002.phpt
      script(
        """<?php
          |
          |$a = array(1,2,3);
          |
          |$o = new stdclass;
          |$o->prop = "value";
          |
          |$c = $a + $o;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Notice: Object of class stdClass could not be converted to int in /zend/AddSpec.inlinePhp on line 8
          |
          |Fatal error: Unsupported operand types in /zend/AddSpec.inlinePhp on line 8
          |""".stripMargin
      )
    }

    "adding arrays to objects" in {
      // ../php-src/Zend/tests/add_003.phpt
      script(
        """<?php
          |
          |$a = array(1,2,3);
          |
          |$o = new stdclass;
          |$o->prop = "value";
          |
          |$c = $o + $a;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Notice: Object of class stdClass could not be converted to int in /zend/AddSpec.inlinePhp on line 8
          |
          |Fatal error: Unsupported operand types in /zend/AddSpec.inlinePhp on line 8
          |""".stripMargin
      )
    }

    "adding numbers to arrays" in {
      // ../php-src/Zend/tests/add_004.phpt
      script(
        """<?php
          |
          |$a = array(1,2,3);
          |
          |$c = $a + 5;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Fatal error: Unsupported operand types in /zend/AddSpec.inlinePhp on line 5
          |""".stripMargin
      )
    }

    "adding integers to doubles" in {
      // ../php-src/Zend/tests/add_005.phpt
      script(
        """<?php
          |
          |$i = 75636;
          |$d = 2834681123.123123;
          |
          |$c = $i + $d;
          |var_dump($c);
          |
          |$c = $d + $i;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """float(2834756759.1231)
          |float(2834756759.1231)
          |Done
          |""".stripMargin
      )
    }

    "adding numbers to strings" in {
      // ../php-src/Zend/tests/add_006.phpt
      script(
        """<?php
          |
          |$i = 75636;
          |$s1 = "this is a string";
          |$s2 = "876222numeric";
          |$s3 = "48474874";
          |$s4 = "25.68";
          |
          |$c = $i + $s1;
          |var_dump($c);
          |
          |$c = $i + $s2;
          |var_dump($c);
          |
          |$c = $i + $s3;
          |var_dump($c);
          |
          |$c = $i + $s4;
          |var_dump($c);
          |
          |$c = $s1 + $i;
          |var_dump($c);
          |
          |$c = $s2 + $i;
          |var_dump($c);
          |
          |$c = $s3 + $i;
          |var_dump($c);
          |
          |$c = $s4 + $i;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(75636)
          |int(951858)
          |int(48550510)
          |float(75661.68)
          |int(75636)
          |int(951858)
          |int(48550510)
          |float(75661.68)
          |Done
          |""".stripMargin
      )
    }

    "adding strings to arrays" in {
      // ../php-src/Zend/tests/add_007.phpt
      script(
        """<?php
          |
          |$a = array(1,2,3);
          |
          |$s1 = "some string";
          |
          |$c = $a + $s1;
          |var_dump($c);
          |
          |echo "Done\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Fatal error: Unsupported operand types in /zend/AddSpec.inlinePhp on line 7
          |""".stripMargin
      )
    }
  }
}
