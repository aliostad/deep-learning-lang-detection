<?php

include_once dirname(__FILE__).'/../Injector.php';
/* Simple harness to test creation and assignment of objects with dependencies */

define('ITERATIONS', 1000);

$start = microtime(true);
injected();
$end = microtime(true) - $start;
echo "Time: $end \n";

$start = microtime(true);
manual();
$end = microtime(true) - $start;
echo "Time: $end \n";

function injected() {
	$injector = new Injector(array('ServiceA', 'ServiceB', 'ServiceC', 'ServiceD', 'ServiceE'));

	for ($i = 0; $i < ITERATIONS; $i++) {
		$obj = $injector->instantiate('MyObject');

		$obj->doSomething();
	}
}

function manual() {
	$a = new ServiceA();
	$b = new ServiceB();
	$c = new ServiceC();
	$d = new ServiceD();
	$e = new ServiceE();

	$b->serviceA = $a;

	$c->serviceA = $a;
	$c->serviceB = $b;

	$d->serviceA = $a;
	$d->serviceB = $b;
	$d->serviceC = $c;

	$e->serviceA = $a;
	$e->serviceB = $b;
	$e->serviceC = $c;
	$e->serviceD = $d;

	for ($i = 0; $i < ITERATIONS; $i++) {
		$obj = new MyObject();
		$obj->serviceA = $a;
		$obj->serviceB = $b;
		$obj->serviceC = $c;
		$obj->setServiceD($d);
		$obj->setServiceE($e);

		$obj->doSomething();
	}
}


class ServiceA {
}

class ServiceB {
	public $serviceA;
}

class ServiceC {
	public $serviceA;
	public $serviceB;
}

class ServiceD {
	public $serviceA;
	public $serviceB;
	public $serviceC;
}

class ServiceE {
	public $serviceA;
	public $serviceB;
	public $serviceC;
	public $serviceD;


}

class MyObject {
	public $serviceA;
	public $serviceB;
	public $serviceC;
	private $serviceD;
	private $serviceE;

	public function setServiceD($v) {
		$this->serviceD = $v;
	}

	public function setServiceE($v) {
		$this->serviceE = $v;
	}

	public function doSomething() {
		if (!isset($this->serviceE->serviceA)) {
		} else {
		}
	}
}