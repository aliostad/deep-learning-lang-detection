/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.zend

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class TryCatchFinallySpec extends SpecificationWithJUnit with TestJbjExecutor {
  "try catch finally" should {
    "Try catch finally" in {
      // ../php-src/Zend/tests/try_catch_finally_001.phpt
      script(
        """<?php
          |
          |class AE extends Exception {};
          |class BE extends Exception {};
          |
          |function foo () {
          |    try {
          |        try {
          |            try {
          |                throw new Exception("try");
          |            } catch (AE $e) {
          |                echo "0";
          |                die("error");
          |            } finally {
          |                echo "1";
          |            }
          |        } finally {
          |            echo "2";
          |        }
          |    } catch (BE $e) {
          |      die("error");
          |    } catch (Exception $e) {
          |        echo "3";
          |    } finally {
          |        echo "4";
          |    }
          |   return 1;
          |}
          |
          |var_dump(foo());
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """1234int(1)
          |""".stripMargin
      )
    }

    "Try catch finally catch(multi catch blocks)" in {
      // ../php-src/Zend/tests/try_catch_finally_002.phpt
      script(
        """<?php
          |
          |class AE extends Exception {};
          |class BE extends Exception {};
          |
          |function foo () {
          |    try {
          |        try {
          |            try {
          |                try {
          |                   echo "1";
          |                   throw new Exception("try");
          |                } catch (AE $e) {
          |                   die("error");
          |                } finally {
          |                   echo "2";
          |                }
          |            } finally {
          |                echo "3";
          |            }
          |        } catch (BE $e) {
          |            die("error");
          |        } finally {
          |            echo "4";
          |        }
          |    } catch (Exception $e) {
          |        echo "5";
          |    } catch (AE $e) {
          |        die("error");
          |    } finally {
          |        echo "6";
          |    }
          |   return 7;
          |}
          |
          |var_dump(foo());
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """123456int(7)
          |""".stripMargin
      )
    }

    "Try catch finally (re-throw exception in catch block)" in {
      // ../php-src/Zend/tests/try_catch_finally_004.phpt
      script(
        """<?php
          |function dummy($msg) {
          |   var_dump($msg);
          |}
          |try {
          |    try {
          |        var_dump("try");
          |        return;
          |    } catch (Exception $e) {
          |        dummy("catch");
          |        throw $e;
          |    } finally {
          |        dummy("finally");
          |    }
          |} catch (Exception $e) {
          |  dummy("catch2");
          |} finally {
          |  dummy("finally2");
          |}
          |var_dump("end");
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """string(3) "try"
          |string(7) "finally"
          |string(8) "finally2"
          |""".stripMargin
      )
    }

    "Try catch finally (break / cont in try block)" in {
      // ../php-src/Zend/tests/try_catch_finally_005.phpt
      script(
        """<?php
          |for ($i = 0;  $i < 100 ; $i ++) {
          |    try {
          |        break;
          |    } finally {
          |        var_dump("break");
          |    }
          |}
          |
          |
          |for ($i = 0;  $i < 2; $i ++) {
          |    try {
          |        continue;
          |    } finally {
          |        var_dump("continue1");
          |    }
          |}
          |
          |for ($i = 0;  $i < 3; $i ++) {
          |    try {
          |        try {
          |            continue;
          |        } finally {
          |            var_dump("continue2");
          |            if ($i == 1) {
          |                throw new Exception("continue exception");
          |            }
          |        }
          |    } catch (Exception $e) {
          |       var_dump("cactched");
          |    }  finally {
          |       var_dump("finally");
          |    }
          |}
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """string(5) "break"
          |string(9) "continue1"
          |string(9) "continue1"
          |string(9) "continue2"
          |string(7) "finally"
          |string(9) "continue2"
          |string(8) "cactched"
          |string(7) "finally"
          |string(9) "continue2"
          |string(7) "finally"
          |""".stripMargin
      )
    }
  }
}
