/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.classes

import de.leanovate.jbj.core.tests.TestJbjExecutor
import org.specs2.mutable.SpecificationWithJUnit

class IncrDercPropertySpec extends SpecificationWithJUnit with TestJbjExecutor{
  "Increment decrement property" should {
    "ZE2 post increment/decrement property of overloaded object" in {
      // classes/incdec_property_001
      script(
        """<?php
          |
          |class Test {
          |	private $real_a = 2;
          |
          |	function __set($property, $value) {
          |	  if ($property == "a") {
          |	    $this->real_a = $value;
          |	  }
          |	}
          |
          |	function __get($property) {
          |	  if ($property == "a") {
          |	    return $this->real_a;
          |	  }
          |	}
          |}
          |
          |$obj = new Test;
          |var_dump($obj->a);
          |$obj->a++;
          |var_dump($obj->a);
          |echo "---Done---\n";
          |?>""".stripMargin
      ).result must haveOutput(
        """int(2)
          |int(3)
          |---Done---
          |""".stripMargin
      )
    }

    "ZE2 post increment/decrement property of overloaded object with assignment" in {
      // classes/incdec_property_002
      script(
        """<?php
          |
          |class Test {
          |	private $real_a = 2;
          |
          |	function __set($property, $value) {
          |	  if ($property == "a") {
          |	    $this->real_a = $value;
          |	  }
          |	}
          |
          |	function __get($property) {
          |	  if ($property == "a") {
          |	    return $this->real_a;
          |	  }
          |	}
          |}
          |
          |$obj = new Test;
          |var_dump($obj->a);
          |$t1 = $obj->a++;
          |var_dump($obj->a);
          |echo "---Done---\n";
          |?>""".stripMargin
      ).result must haveOutput(
        """int(2)
          |int(3)
          |---Done---
          |""".stripMargin
      )
    }

    "ZE2 pre increment/decrement property of overloaded object" in {
      // classes/incdec_property_003
      script(
        """<?php
          |
          |class Test {
          |	private $real_a = 2;
          |
          |	function __set($property, $value) {
          |	  if ($property == "a") {
          |	    $this->real_a = $value;
          |	  }
          |	}
          |
          |	function __get($property) {
          |	  if ($property == "a") {
          |	    return $this->real_a;
          |	  }
          |	}
          |}
          |
          |$obj = new Test;
          |var_dump($obj->a);
          |++$obj->a;
          |var_dump($obj->a);
          |echo "---Done---\n";
          |?>""".stripMargin
      ).result must haveOutput(
        """int(2)
          |int(3)
          |---Done---
          |""".stripMargin
      )
    }

    "ZE2 pre increment/decrement property of overloaded object with assignment" in {
      // classes/incdec_property_004
      script(
        """<?php
          |
          |class Test {
          |	private $real_a = 2;
          |
          |	function __set($property, $value) {
          |	  if ($property == "a") {
          |	    $this->real_a = $value;
          |	  }
          |	}
          |
          |	function __get($property) {
          |	  if ($property == "a") {
          |	    return $this->real_a;
          |	  }
          |	}
          |}
          |
          |$obj = new Test;
          |var_dump($obj->a);
          |$t1 = ++$obj->a;
          |var_dump($obj->a);
          |echo "---Done---\n";
          |?>""".stripMargin
      ).result must haveOutput(
        """int(2)
          |int(3)
          |---Done---
          |""".stripMargin
      )
    }
  }
}
