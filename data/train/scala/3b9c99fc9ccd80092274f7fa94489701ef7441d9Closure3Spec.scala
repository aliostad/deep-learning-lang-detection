/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.zend

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class Closure3Spec extends SpecificationWithJUnit with TestJbjExecutor {
  "Closure tests 020-029" should {
    "Closure 020: Trying to access private property outside class" in {
      // Zend/tests/closure_020.phpt
      script(
        """<?php
          |
          |class foo {
          |	private $test = 3;
          |
          |	public function x() {
          |		$a = &$this;
          |		$this->a = function() use (&$a) { return $a; };
          |		var_dump($this->a->__invoke());
          |		var_dump(is_a($this->a, 'closure'));
          |		var_dump(is_callable($this->a));
          |
          |		return $this->a;
          |	}
          |}
          |
          |$foo = new foo;
          |$y = $foo->x();
          |var_dump($y()->test);
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """object(foo)#1 (2) {
          |  ["test":"foo":private]=>
          |  int(3)
          |  ["a"]=>
          |  object(Closure)#2 (2) {
          |    ["static"]=>
          |    array(1) {
          |      ["a"]=>
          |      *RECURSION*
          |    }
          |    ["this"]=>
          |    *RECURSION*
          |  }
          |}
          |bool(true)
          |bool(true)
          |
          |Fatal error: Cannot access private property foo::$test in /zend/Closure3Spec.inlinePhp on line 19
          |""".stripMargin
      )
    }

    "Closure 021: Throwing exception inside lambda" in {
      // Zend/tests/closure_021.phpt
      script(
        """<?php
          |
          |$foo = function() {
          |	try {
          |		throw new Exception('test!');
          |	} catch(Exception $e) {
          |		throw $e;
          |	}
          |};
          |
          |try {
          |	$foo();
          |} catch (Exception $e) {
          |	var_dump($e->getMessage());
          |}
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """string(5) "test!"
          |""".stripMargin
      )
    }

    "Closure 022: Closure properties" in {
      // Zend/tests/closure_022.phpt
      script(
        """<?php
          |$a = 0;
          |$foo = function() use ($a) {
          |};
          |$foo->a = 1;
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Catchable fatal error: Closure object cannot have properties in /zend/Closure3Spec.inlinePhp on line 5
          |""".stripMargin
      )
    }

    "Closure 023: Closure declared in statically called method" in {
      // Zend/tests/closure_023.phpt
      script(
        """<?php
          |class foo {
          |    public static function bar() {
          |        $func = function() { echo "Done"; };
          |        $func();
          |    }
          |}
          |foo::bar();
          |""".stripMargin
      ).result must haveOutput(
        """Done""".stripMargin
      )
    }

    "Closure 024: Clone the Closure object" in {
      // Zend/tests/closure_024.phpt
      script(
        """<?php
          |
          |$a = 1;
          |$c = function($add) use(&$a) { return $a+$add; };
          |
          |$cc = clone $c;
          |
          |echo $c(10)."\n";
          |echo $cc(10)."\n";
          |
          |$a++;
          |
          |echo $c(10)."\n";
          |echo $cc(10)."\n";
          |
          |echo "Done.\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """11
          |11
          |12
          |12
          |Done.
          |""".stripMargin
      )
    }

    "Closure 025: Using closure in create_function()" in {
      // Zend/tests/closure_025.phpt
      script(
        """<?php
          |
          |$a = create_function('$x', 'return function($y) use ($x) { return $x * $y; };');
          |
          |var_dump($a(2)->__invoke(4));
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(8)
          |""".stripMargin
      )
    }

    "Closure 026: Assigning a closure object to an array in $this" in {
      // Zend/tests/closure_026.phpt
      script(
        """<?php
          |
          |class foo {
          |	public function __construct() {
          |		$a =& $this;
          |
          |		$a->a[] = function() {
          |			return 1;
          |		};
          |
          |		var_dump($this);
          |
          |		var_dump($this->a[0]());
          |	}
          |}
          |
          |$x = new foo;
          |
          |print "--------------\n";
          |
          |foreach ($x as $b => $c) {
          |	var_dump($b, $c);
          |	var_dump($c[0]());
          |}
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """object(foo)#1 (1) {
          |  ["a"]=>
          |  array(1) {
          |    [0]=>
          |    object(Closure)#2 (1) {
          |      ["this"]=>
          |      *RECURSION*
          |    }
          |  }
          |}
          |int(1)
          |--------------
          |string(1) "a"
          |array(1) {
          |  [0]=>
          |  object(Closure)#2 (1) {
          |    ["this"]=>
          |    object(foo)#1 (1) {
          |      ["a"]=>
          |      *RECURSION*
          |    }
          |  }
          |}
          |int(1)
          |""".stripMargin
      )
    }

    "Closure 027: Testing Closure type-hint" in {
      // Zend/tests/closure_027.phpt
      script(
        """<?php
          |
          |function test(closure $a) {
          |	var_dump($a());
          |}
          |
          |
          |test(function() { return new stdclass; });
          |
          |test(function() { });
          |
          |$a = function($x) use ($y) {};
          |test($a);
          |
          |test(new stdclass);
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """object(stdClass)#2 (0) {
          |}
          |NULL
          |
          |Notice: Undefined variable: y in /zend/Closure3Spec.inlinePhp on line 12
          |
          |Warning: Missing argument 1 for {closure}(), called in /zend/Closure3Spec.inlinePhp on line 4 and defined in /zend/Closure3Spec.inlinePhp on line 12
          |NULL
          |
          |Catchable fatal error: Argument 1 passed to test() must be an instance of Closure, instance of stdClass given, called in /zend/Closure3Spec.inlinePhp on line 15 and defined in /zend/Closure3Spec.inlinePhp on line 3
          |""".stripMargin
      )
    }

    "Closure 028: Trying to use lambda directly in foreach" in {
      // Zend/tests/closure_028.phpt
      script(
        """<?php
          |
          |foreach (function(){ return 1; } as $y) {
          |	var_dump($y);
          |}
          |
          |print "ok\n";
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """ok
          |""".stripMargin
      )
    }

    "Closure 029: Testing lambda with instanceof operator" in {
      // Zend/tests/closure_029.phpt
      script(
        """<?php
          |
          |var_dump(function() { } instanceof closure);
          |var_dump(function(&$x) { } instanceof closure);
          |var_dump(@function(&$x) use ($y, $z) { } instanceof closure);
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """bool(true)
          |bool(true)
          |bool(true)
          |""".stripMargin
      )
    }
  }
}
