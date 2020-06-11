/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.parsing

import de.leanovate.jbj.core.tests.TestJbjExecutor
import org.specs2.mutable.SpecificationWithJUnit

class NumericLiteralsSpec extends SpecificationWithJUnit with TestJbjExecutor{
  "Numeric literals" should {
    "Integer and float" in {
      script(
        """<?php
          |var_dump(1234);
          |var_dump(+456);
          |var_dump(-123);
          |var_dump(0x4d2);
          |var_dump(+0x1C8);
          |var_dump(-0x76);
          |var_dump(02322);
          |var_dump(+0710);
          |var_dump(-0173);
          |var_dump(0b10011010010);
          |var_dump(+0b111001000);
          |var_dump(-0b1111011);
          |
          |var_dump(.123);
          |var_dump(+.123);
          |var_dump(-.123);
          |var_dump(123.);
          |var_dump(+123.);
          |var_dump(-123.);
          |var_dump(123.4);
          |var_dump(+123.4);
          |var_dump(-123.4);
          |
          |var_dump(.123E5);
          |var_dump(.123E+5);
          |var_dump(.123e-5);
          |var_dump(123.E5);
          |var_dump(123e5);
          |
          |$large_number = 9223372036854775807;
          |var_dump($large_number);                     // int(9223372036854775807)
          |
          |$large_number = 9223372036854775808;
          |var_dump($large_number);                     // float(9.2233720368548E+18)
          |
          |$million = 1000000;
          |$large_number =  50000000000000 * $million;
          |var_dump($large_number);                     // float(5.0E+19)
          |?>""".stripMargin
      ).result must haveOutput (
        """int(1234)
          |int(456)
          |int(-123)
          |int(1234)
          |int(456)
          |int(-118)
          |int(1234)
          |int(456)
          |int(-123)
          |int(1234)
          |int(456)
          |int(-123)
          |float(0.123)
          |float(0.123)
          |float(-0.123)
          |float(123)
          |float(123)
          |float(-123)
          |float(123.4)
          |float(123.4)
          |float(-123.4)
          |float(12300)
          |float(12300)
          |float(0.00000123)
          |float(12300000)
          |float(12300000)
          |int(9223372036854775807)
          |float(9.2233720368548E+18)
          |float(5E+19)
          |""".stripMargin
      )
    }
  }
}
