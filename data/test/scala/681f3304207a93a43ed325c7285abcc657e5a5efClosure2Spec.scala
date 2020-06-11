/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.zend

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class Closure2Spec extends SpecificationWithJUnit with TestJbjExecutor {
  "Closure tests 010-019" should {
    "Closure 010: Closure calls itself" in {
      // Zend/tests/closure_010.phpt
      script(
        """<?php
          |$i = 3;
          |$lambda = function ($lambda) use (&$i) {
          |    if ($i==0) return;
          |    echo $i--."\n";
          |    $lambda($lambda);
          |};
          |$lambda($lambda);
          |echo "$i\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """3
          |2
          |1
          |0
          |""".stripMargin
      )
    }

    "Closure 011: Lexical copies not static in closure" in {
      // Zend/tests/closure_011.phpt
      script(
        """<?php
          |$i = 1;
          |$lambda = function () use ($i) {
          |    return ++$i;
          |};
          |$lambda();
          |echo $lambda()."\n";
          |//early prototypes gave 3 here because $i was static in $lambda
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """2
          |""".stripMargin
      )
    }

    "Closure 012: Undefined lexical variables" in {
      // Zend/tests/closure_012.phpt
      script(
        """<?php
          |$lambda = function () use ($i) {
          |    return ++$i;
          |};
          |$lambda();
          |$lambda();
          |var_dump($i);
          |$lambda = function () use (&$i) {
          |    return ++$i;
          |};
          |$lambda();
          |$lambda();
          |var_dump($i);
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Notice: Undefined variable: i in /zend/Closure2Spec.inlinePhp on line 2
          |
          |Notice: Undefined variable: i in /zend/Closure2Spec.inlinePhp on line 7
          |NULL
          |int(2)
          |""".stripMargin
      )
    }

    "Closure 013: __invoke() on temporary result" in {
      // Zend/tests/closure_013.phpt
      script(
        """<?php
          |class Foo {
          |	function __invoke() {
          |		echo "Hello World!\n";
          |	}
          |}
          |
          |function foo() {
          |	return function() {
          |		echo "Hello World!\n";
          |	};
          |}
          |$test = new Foo;
          |$test->__invoke();
          |$test = foo();
          |$test->__invoke();
          |$test = foo()->__invoke();
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """Hello World!
          |Hello World!
          |Hello World!
          |""".stripMargin
      )
    }

    "Closure 014: return by value/reference" in {
      // Zend/tests/closure_014.phpt
      script(
        """<?php
          |class C1 {
          |	function __invoke() {
          |		return 0;
          |	}
          |}
          |class C2 {
          |	function &__invoke(&$a) {
          |		return $a;
          |	}
          |}
          |class C3 {
          |	function __invoke() {
          |	}
          |}
          |
          |$x = new C1();
          |var_dump($x());
          |var_dump($x->__invoke());
          |$x();
          |$x->__invoke();
          |$x = function() {
          |	return 0;
          |};
          |var_dump($x());
          |var_dump($x->__invoke());
          |$x();
          |$x->__invoke();
          |
          |$x = new C2();
          |$a = $b = $c = $d = 1;
          |$e =& $x($a);
          |$e = 2;
          |var_dump($a);
          |$e =& $x->__invoke($b);
          |$e = 3;
          |var_dump($b);
          |$x($b);
          |$x->__invoke($b);
          |$x = function & (&$a) {
          |	return $a;
          |};
          |$e =& $x($c);
          |$e = 4;
          |var_dump($c);
          |$e =& $x->__invoke($d);
          |$e = 5;
          |var_dump($d);
          |$x($d);
          |$x->__invoke($d);
          |
          |$x = new C3();
          |var_dump($x());
          |var_dump($x->__invoke());
          |$x();
          |$x->__invoke();
          |$x = function() {
          |};
          |var_dump($x());
          |var_dump($x->__invoke());
          |$x();
          |$x->__invoke();
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(0)
          |int(0)
          |int(0)
          |int(0)
          |int(2)
          |int(3)
          |int(4)
          |int(5)
          |NULL
          |NULL
          |NULL
          |NULL
          |""".stripMargin
      )
    }

    "Closure 015: converting to string/unicode" in {
      // Zend/tests/closure_015.phpt
      script(
        """<?php
          |set_error_handler('myErrorHandler', E_RECOVERABLE_ERROR);
          |function myErrorHandler($errno, $errstr, $errfile, $errline) {
          |  echo "Error: $errstr at $errfile($errline)\n";
          |  return true;
          |}
          |$x = function() { return 1; };
          |print (string) $x;
          |print "\n";
          |print $x;
          |print "\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """Error: Object of class Closure could not be converted to string at /zend/Closure2Spec.inlinePhp(8)
          |
          |Error: Object of class Closure could not be converted to string at /zend/Closure2Spec.inlinePhp(10)
          |
          |""".stripMargin
      )
    }

    "Closure 016: closures and is_callable()" in {
      // Zend/tests/closure_016.phpt
      script(
        """<?php
          |class Foo {
          |	function __invoke() {
          |		echo "Hello World!\n";
          |	}
          |}
          |
          |function foo() {
          |	return function() {
          |		echo "Hello World!\n";
          |	};
          |}
          |$test = new Foo;
          |var_dump(is_callable($test, true, $name));
          |echo $name."\n";
          |var_dump(is_callable($test, false, $name));
          |echo $name."\n";
          |var_dump(is_callable(array($test,"__invoke"), true, $name));
          |echo $name."\n";
          |var_dump(is_callable(array($test,"__invoke"), false, $name));
          |echo $name."\n";
          |$test = foo();
          |var_dump(is_callable($test, true, $name));
          |echo $name."\n";
          |var_dump(is_callable($test, false, $name));
          |echo $name."\n";
          |var_dump(is_callable(array($test,"__invoke"), true, $name));
          |echo $name."\n";
          |var_dump(is_callable(array($test,"__invoke"), false, $name));
          |echo $name."\n";
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """bool(true)
          |Foo::__invoke
          |bool(true)
          |Foo::__invoke
          |bool(true)
          |Foo::__invoke
          |bool(true)
          |Foo::__invoke
          |bool(true)
          |Closure::__invoke
          |bool(true)
          |Closure::__invoke
          |bool(true)
          |Closure::__invoke
          |bool(true)
          |Closure::__invoke
          |""".stripMargin
      )
    }

    "Closure 017: Trying to destroy an active lambda function" in {
      // Zend/tests/closure_017.phpt
      script(
        """<?php
          |
          |$a = function(&$a) { $a = 1; };
          |
          |$a($a);
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Fatal error: Cannot destroy active lambda function in /zend/Closure2Spec.inlinePhp on line 3
          |""".stripMargin
      )
    }

    "Closure 018: Assigning lambda to static var and returning by ref" in {
      // Zend/tests/closure_018.phpt
      script(
        """<?php
          |
          |class foo {
          |	public function test(&$x) {
          |		static $lambda;
          |		$lambda = function &() use (&$x) {
          |			return $x = $x * $x;
          |		};
          |		return $lambda();
          |	}
          |}
          |
          |$test = new foo;
          |
          |$y = 2;
          |var_dump($test->test($y));
          |var_dump($x = $test->test($y));
          |var_dump($y, $x);
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(4)
          |int(16)
          |int(16)
          |int(16)
          |""".stripMargin
      )
    }

    "Closure 019: Calling lambda using $GLOBALS and global $var" in {
      // Zend/tests/closure_019.phpt
      script(
        """<?php
          |
          |$lambda = function &(&$x) {
          |	return $x = $x * $x;
          |};
          |
          |function test() {
          |	global $lambda;
          |
          |	$y = 3;
          |	var_dump($GLOBALS['lambda']($y));
          |	var_dump($lambda($y));
          |	var_dump($GLOBALS['lambda'](1));
          |}
          |
          |test();
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(9)
          |int(81)
          |
          |Fatal error: Cannot pass parameter 1 by reference in /zend/Closure2Spec.inlinePhp on line 13
          |""".stripMargin
      )
    }
  }
}
