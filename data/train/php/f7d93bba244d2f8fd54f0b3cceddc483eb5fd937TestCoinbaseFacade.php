<?php namespace Yani\Coinbase\Tests;

use Yani\Coinbase\Facades\Coinbase;

final class TestCoinbase extends Coinbase {

	/**
	 * Call and return getFacadeAccessor() method
	 *
	 * @return string
	 */
	public function returnGetFacadeAccessor()
	{
		return $this->getFacadeAccessor();
	}
}

class TestCoinbaseFacede extends \PHPUnit_Framework_TestCase {

	/**
	 * Test getFacadeAccessor
	 */
	public function testgetFacadeAccessor()
	{
		$coinbase = new TestCoinbase();
		$this->assertEquals('coinbase', $coinbase->returnGetFacadeAccessor());
	}
}
