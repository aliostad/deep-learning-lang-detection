package de.leanovate.jbj.core.tests.special

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class FileIOSpec extends SpecificationWithJUnit with TestJbjExecutor {
  "file I/O functions" should {
    "be able to write/append and read temporary files" in {
      script(
        """<?php
          |$filename = tempnam("/tmp", "test_");
          |var_dump(file_exists($filename));
          |var_dump(is_writable($filename));
          |
          |$f = fopen($filename, "w");
          |for($i = 1; $i <= 10; $i++) {
          |  var_dump(fwrite($f, "Line $i\n"));
          |}
          |var_dump(fclose($f));
          |
          |$f = fopen($filename, "a");
          |for($i = 1; $i <= 10; $i++) {
          |  var_dump(fwrite($f, "Append $i\n"));
          |}
          |var_dump(fclose($f));
          |
          |$f = fopen($filename, "r");
          |var_dump(fread($f, 8192));
          |var_dump(fclose($f));
          |?>""".stripMargin
      ).result must haveOutput(
        """bool(true)
          |bool(true)
          |int(7)
          |int(7)
          |int(7)
          |int(7)
          |int(7)
          |int(7)
          |int(7)
          |int(7)
          |int(7)
          |int(8)
          |bool(true)
          |int(9)
          |int(9)
          |int(9)
          |int(9)
          |int(9)
          |int(9)
          |int(9)
          |int(9)
          |int(9)
          |int(10)
          |bool(true)
          |string(162) "Line 1
          |Line 2
          |Line 3
          |Line 4
          |Line 5
          |Line 6
          |Line 7
          |Line 8
          |Line 9
          |Line 10
          |Append 1
          |Append 2
          |Append 3
          |Append 4
          |Append 5
          |Append 6
          |Append 7
          |Append 8
          |Append 9
          |Append 10
          |"
          |bool(true)
          |""".stripMargin
      )
    }
  }
}
