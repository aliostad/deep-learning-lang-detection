<?php
/* Copy Test cases generated on: 2011-11-14 14:38:52 : 1321277932*/
App::uses('Copy', 'Model');

/**
 * Copy Test Case
 *
 */
class CopyTestCase extends CakeTestCase {
/**
 * Fixtures
 *
 * @var array
 */
	public $fixtures = array('app.copy', 'app.film', 'app.hire');

/**
 * setUp method
 *
 * @return void
 */
	public function setUp() {
		parent::setUp();

		$this->Copy = ClassRegistry::init('Copy');
	}

/**
 * tearDown method
 *
 * @return void
 */
	public function tearDown() {
		unset($this->Copy);

		parent::tearDown();
	}

}
