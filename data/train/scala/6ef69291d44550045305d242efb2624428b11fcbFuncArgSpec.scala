/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.lang

import org.specs2.mutable.SpecificationWithJUnit
import de.leanovate.jbj.core.tests.TestJbjExecutor

class FuncArgSpec extends SpecificationWithJUnit with TestJbjExecutor {
  "func get arg" should {
    "func_get_arg test" in {
      // lang/func_get_arg.001.phpt
      script(
        """<?php
          |
          |function foo($a)
          |{
          |   $a=5;
          |   echo func_get_arg(0);
          |}
          |foo(2);
          |echo "\n";
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """2
          | """.stripMargin
      )
    }

    "func_get_arg with variable number of args" in {
      // lang/func_get_arg.002.phpt
      script(
        """<?php
          |
          |function foo($a)
          |{
          |	$b = func_get_arg(1);
          |	var_dump($b);
          |	$b++;
          |	var_dump(func_get_arg(1));
          |
          |}
          |foo(2, 3);
          |echo "\n";
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """int(3)
          |int(3)
          |
          | """.stripMargin
      )
    }

    "func_get_arg outside of a function declaration" in {
      // lang/func_get_arg.003.phpt
      script(
        """<?php
          |
          |var_dump (func_get_arg(0));
          |
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """
          |Warning: func_get_arg():  Called from the global scope - no function context in /lang/FuncArgSpec.inlinePhp on line 3
          |bool(false)
          | """.stripMargin
      )
    }

    "func_get_arg on non-existent arg" in {
      // lang/func_get_arg.004.phpt
      script(
        """<?php
          |
          |function foo($a)
          |{
          |	var_dump(func_get_arg(2));
          |}
          |foo(2, 3);
          |echo "\n";
          |
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """
          |Warning: func_get_arg():  Argument 2 not passed to function in /lang/FuncArgSpec.inlinePhp on line 5
          |bool(false)
          |
          | """.stripMargin
      )
    }

    "A variable, which is referenced by another variable, is passed by value." in {
      // lang/func_get_arg.005.phpt
      script(
        """<?php
          |function refVal($x) {
          |	global $a;
          |	$a = 'changed.a';
          |	var_dump($x);
          |	var_dump(func_get_arg(0));
          |}
          |
          |$a = "original.a";
          |$ref =& $a;
          |refVal($a);
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """string(10) "original.a"
          |string(10) "original.a"
          | """.stripMargin
      )
    }

    "func_get_arg test" in {
      // lang/func_get_arg_variation.phpt
      script(
        """<?php
          |
          |function foo($a)
          |{
          |   $a=5;
          |   echo func_get_arg();
          |   echo func_get_arg(2,2);
          |   echo func_get_arg("hello");
          |   echo func_get_arg(-1);
          |   echo func_get_arg(2);
          |}
          |foo(2);
          |echo "\n";
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """
          |Warning: func_get_arg() expects exactly 1 parameter, 0 given in /lang/FuncArgSpec.inlinePhp on line 6
          |
          |Warning: func_get_arg() expects exactly 1 parameter, 2 given in /lang/FuncArgSpec.inlinePhp on line 7
          |
          |Warning: func_get_arg() expects parameter 1 to be long, string given in /lang/FuncArgSpec.inlinePhp on line 8
          |
          |Warning: func_get_arg():  The argument number should be >= 0 in /lang/FuncArgSpec.inlinePhp on line 9
          |
          |Warning: func_get_arg():  Argument 2 not passed to function in /lang/FuncArgSpec.inlinePhp on line 10
          |
          | """.stripMargin
      )
    }
  }

  "func_get_args" should {
    "func_get_args with no args" in {
      // lang/func_get_args.001.phpt
      script(
        """<?php
          |
          |function foo()
          |{
          |	var_dump(func_get_args());
          |}
          |foo();
          |
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """array(0) {
          |}
          | """.stripMargin
      )
    }

    "func_get_args with variable number of args" in {
      // lang/func_get_args.002.phpt
      script(
        """<?php
          |
          |function foo($a)
          |{
          |	var_dump(func_get_args());
          |}
          |foo(1, 2, 3);
          |
          |?>
          | """.stripMargin
      ).result must haveOutput(
        """array(3) {
          |  [0]=>
          |  int(1)
          |  [1]=>
          |  int(2)
          |  [2]=>
          |  int(3)
          |}
          | """.stripMargin
      )
    }

    "func_get_args() outside of a function declaration" in {
      // lang/func_get_args.003.phpt
      script(
        """<?php
          |
          |var_dump(func_get_args());
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Warning: func_get_args():  Called from the global scope - no function context in /lang/FuncArgSpec.inlinePhp on line 3
          |bool(false)
          |""".stripMargin
      )
    }

    "Pass same variable by ref and by value." in {
      // lang/func_get_args.004.phpt
      script(
        """<?php
          |function valRef($x, &$y) {
          |	var_dump($x, $y);
          |	var_dump(func_get_args());
          |	$x = 'changed.x';
          |	$y = 'changed.y';
          |	var_dump(func_get_args());
          |}
          |
          |function refVal(&$x, $y) {
          |	var_dump($x, $y);
          |	var_dump(func_get_args());
          |	$x = 'changed.x';
          |	$y = 'changed.y';
          |	var_dump(func_get_args());
          |}
          |
          |
          |echo "\n\n-- Val, Ref --\n";
          |$a = 'original.a';
          |valRef($a, $a);
          |var_dump($a);
          |
          |echo "\n\n-- Ref, Val --\n";
          |$b = 'original.b';
          |refVal($b, $b);
          |var_dump($b);
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |
          |-- Val, Ref --
          |string(10) "original.a"
          |string(10) "original.a"
          |array(2) {
          |  [0]=>
          |  string(10) "original.a"
          |  [1]=>
          |  string(10) "original.a"
          |}
          |array(2) {
          |  [0]=>
          |  string(10) "original.a"
          |  [1]=>
          |  string(9) "changed.y"
          |}
          |string(9) "changed.y"
          |
          |
          |-- Ref, Val --
          |string(10) "original.b"
          |string(10) "original.b"
          |array(2) {
          |  [0]=>
          |  string(10) "original.b"
          |  [1]=>
          |  string(10) "original.b"
          |}
          |array(2) {
          |  [0]=>
          |  string(9) "changed.x"
          |  [1]=>
          |  string(10) "original.b"
          |}
          |string(9) "changed.x"
          |""".stripMargin
      )
    }
  }

  "func_num_args" should {
    "func_num_args with no args" in {
      // lang/func_num_args.001.phpt
      script(
        """<?php
          |
          |function foo()
          |{
          |	var_dump(func_num_args());
          |}
          |foo();
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(0)
          |""".stripMargin
      )
    }

    "func_num_args with variable number of args" in {
      // lang/func_num_args.002.phpt
      script(
        """<?php
          |
          |function foo($a)
          |{
          |	var_dump(func_num_args());
          |}
          |foo(1, 2, 3);
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """int(3)
          |""".stripMargin
      )
    }

    "func_num_args() outside of a function declaration" in {
      // lang/func_num_args.003.phpt
      script(
        """<?php
          |
          |var_dump(func_num_args());
          |
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |Warning: func_num_args():  Called from the global scope - no function context in /lang/FuncArgSpec.inlinePhp on line 3
          |int(-1)
          |""".stripMargin
      )
    }

    "Pass same variable by ref and by value." in {
      // lang/func_num_args.004.phpt
      script(
        """<?php
          |function valRef($x, &$y) {
          |	var_dump($x, $y);
          |	var_dump(func_num_args());
          |	$x = 'changed.x';
          |	$y = 'changed.y';
          |	var_dump(func_num_args());
          |}
          |
          |function refVal(&$x, $y) {
          |	var_dump($x, $y);
          |	var_dump(func_num_args());
          |	$x = 'changed.x';
          |	$y = 'changed.y';
          |	var_dump(func_num_args());
          |}
          |
          |
          |echo "\n\n-- Val, Ref --\n";
          |$a = 'original.a';
          |valRef($a, $a);
          |var_dump($a);
          |
          |echo "\n\n-- Ref, Val --\n";
          |$b = 'original.b';
          |refVal($b, $b);
          |var_dump($b);
          |?>
          |""".stripMargin
      ).result must haveOutput(
        """
          |
          |-- Val, Ref --
          |string(10) "original.a"
          |string(10) "original.a"
          |int(2)
          |int(2)
          |string(9) "changed.y"
          |
          |
          |-- Ref, Val --
          |string(10) "original.b"
          |string(10) "original.b"
          |int(2)
          |int(2)
          |string(9) "changed.x"
          |""".stripMargin
      )
    }
  }
}
