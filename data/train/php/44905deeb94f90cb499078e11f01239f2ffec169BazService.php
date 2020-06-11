<?php
namespace Service;

class BazService {

	protected $fooService;
	protected $fooOneBarService;

	public function __construct() {
		print __CLASS__ . '->' . __FUNCTION__ . '()' . PHP_EOL;
	}

	public function setFooService($fooService) {
		print __CLASS__ . '->' . __FUNCTION__ . '()' . PHP_EOL;
		$this->fooService = $fooService;
	}

	public function setBar($barService) {
		print __CLASS__ . '->' . __FUNCTION__ . '()' . PHP_EOL;
		$this->barService = $barService;
	}

	public function setFooOneBarService(\Service\Foo\One\BarService $fooOneBarService) {
		$this->fooOneBarService = $fooOneBarService;
	}
}


