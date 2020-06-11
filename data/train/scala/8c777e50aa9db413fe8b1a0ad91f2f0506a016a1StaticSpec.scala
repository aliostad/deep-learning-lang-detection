/*    _ _     _                                        *\
**   (_) |__ (_)  License: MIT  (2013)                 **
**   | |  _ \| |    http://opensource.org/licenses/MIT **
**   | | |_) | |                                       **
**  _/ |____// |  Author: Bodo Junglas                 **
\* |__/    |__/                 (Tests based on PHP)   */

package de.leanovate.jbj.core.tests.lang

import de.leanovate.jbj.core.tests.TestJbjExecutor
import org.specs2.mutable.SpecificationWithJUnit

class StaticSpec extends SpecificationWithJUnit with TestJbjExecutor {
  "Static tests" should {
    "Static keyword - basic tests" in {
      // lang/static_basic_001
      script(
        """<?php
          |
          |echo "\nSame variable used as static and non static.\n";
          |function staticNonStatic() {
          |	echo "---------\n";
          |	$a=0;
          |	echo "$a\n";
          |	static $a=10;
          |	echo "$a\n";
          |	$a++;
          |}
          |staticNonStatic();
          |staticNonStatic();
          |staticNonStatic();
          |
          |echo "\nLots of initialisations in the same statement.\n";
          |function manyInits() {
          |	static $counter=0;
          |	echo "------------- Call $counter --------------\n";
          |	static $a, $b=10, $c=20, $d, $e=30;
          |	echo "Unitialised      :$a\n";
          |	echo "Initialised to 10:$b\n";
          |	echo "Initialised to 20:$c\n";
          |	echo "Unitialised      :$d\n";
          |	echo "Initialised to 30:$e\n";
          |	$a++;
          |	$b++;
          |	$c++;
          |	$d++;
          |	$e++;
          |	$counter++;
          |}
          |manyInits();
          |manyInits();
          |manyInits();
          |
          |echo "\nUsing static keyword at global scope\n";
          |for ($i=0; $i<3; $i++) {
          |   static $s, $k=10;
          |   echo "$s $k\n";
          |   $s++;
          |   $k++;
          |}
          |?>""".stripMargin
      ).result must haveOutput(
        """
          |Same variable used as static and non static.
          |---------
          |0
          |10
          |---------
          |0
          |11
          |---------
          |0
          |12
          |
          |Lots of initialisations in the same statement.
          |------------- Call 0 --------------
          |Unitialised      :
          |Initialised to 10:10
          |Initialised to 20:20
          |Unitialised      :
          |Initialised to 30:30
          |------------- Call 1 --------------
          |Unitialised      :1
          |Initialised to 10:11
          |Initialised to 20:21
          |Unitialised      :1
          |Initialised to 30:31
          |------------- Call 2 --------------
          |Unitialised      :2
          |Initialised to 10:12
          |Initialised to 20:22
          |Unitialised      :2
          |Initialised to 30:32
          |
          |Using static keyword at global scope
          | 10
          |1 11
          |2 12
          |""".stripMargin
      )
    }

    "Multiple declarations of the same static variable" in {
      // lang/static_basic_002
      script(
        """<?php
          |
          |$a = 5;
          |
          |var_dump($a);
          |
          |static $a = 10;
          |static $a = 11;
          |
          |var_dump($a);
          |
          |function foo() {
          |	static $a = 13;
          |	static $a = 14;
          |
          |	var_dump($a);
          |}
          |
          |foo();
          |
          |?>""".stripMargin
      ).result must haveOutput (
        """int(5)
          |int(11)
          |int(14)
          |""".stripMargin
      )
    }

    "Statics in nested functions & evals." in {
      // lang/static_variation_001
      script(
        """<?php
          |
          |static $a = array(7,8,9);
          |
          |function f1() {
          |	static $a = array(1,2,3);
          |
          |	function g1() {
          |		static $a = array(4,5,6);
          |		var_dump($a);
          |	}
          |
          |	var_dump($a);
          |
          |}
          |
          |f1();
          |g1();
          |var_dump($a);
          |
          |eval(' static $b = array(10,11,12); ');
          |
          |function f2() {
          |	eval(' static $b = array(1,2,3); ');
          |
          |	function g2a() {
          |		eval(' static $b = array(4,5,6); ');
          |		var_dump($b);
          |	}
          |
          |	eval('function g2b() { static $b = array(7, 8, 9); var_dump($b); } ');
          |	var_dump($b);
          |}
          |
          |f2();
          |g2a();
          |g2b();
          |var_dump($b);
          |
          |
          |eval(' function f3() { static $c = array(1,2,3); var_dump($c); }');
          |f3();
          |
          |?>""".stripMargin
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
          |  int(4)
          |  [1]=>
          |  int(5)
          |  [2]=>
          |  int(6)
          |}
          |array(3) {
          |  [0]=>
          |  int(7)
          |  [1]=>
          |  int(8)
          |  [2]=>
          |  int(9)
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
          |  [0]=>
          |  int(4)
          |  [1]=>
          |  int(5)
          |  [2]=>
          |  int(6)
          |}
          |array(3) {
          |  [0]=>
          |  int(7)
          |  [1]=>
          |  int(8)
          |  [2]=>
          |  int(9)
          |}
          |array(3) {
          |  [0]=>
          |  int(10)
          |  [1]=>
          |  int(11)
          |  [2]=>
          |  int(12)
          |}
          |array(3) {
          |  [0]=>
          |  int(1)
          |  [1]=>
          |  int(2)
          |  [2]=>
          |  int(3)
          |}
          |""".stripMargin
      )
    }

    "Static variables in methods & nested functions & evals." in {
      // lang/static_variation_002
      script(
        """<?php
          |
          |Class C {
          |	function f() {
          |		static $a = array(1,2,3);
          |		eval(' static $k = array(4,5,6); ');
          |
          |		function cfg() {
          |			static $a = array(7,8,9);
          |			eval(' static $k = array(10,11,12); ');
          |			var_dump($a, $k);
          |		}
          |		var_dump($a, $k);
          |	}
          |}
          |$c = new C;
          |$c->f();
          |cfg();
          |
          |Class D {
          |	static function f() {
          |		eval('function dfg() { static $b = array(1,2,3); var_dump($b); } ');
          |	}
          |}
          |D::f();
          |dfg();
          |
          |eval(' Class E { function f() { static $c = array(1,2,3); var_dump($c); } }');
          |$e = new E;
          |$e->f();
          |
          |?>""".stripMargin
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
          |  int(4)
          |  [1]=>
          |  int(5)
          |  [2]=>
          |  int(6)
          |}
          |array(3) {
          |  [0]=>
          |  int(7)
          |  [1]=>
          |  int(8)
          |  [2]=>
          |  int(9)
          |}
          |array(3) {
          |  [0]=>
          |  int(10)
          |  [1]=>
          |  int(11)
          |  [2]=>
          |  int(12)
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
          |  [0]=>
          |  int(1)
          |  [1]=>
          |  int(2)
          |  [2]=>
          |  int(3)
          |}
          |""".stripMargin
      )
    }
  }
}
