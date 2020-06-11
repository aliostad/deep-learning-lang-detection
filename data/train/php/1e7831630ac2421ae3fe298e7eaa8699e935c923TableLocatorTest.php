<?php
/**
 * @package system.tests
 */
class System_Locator_TableLocatorTest extends System_Test_TestCase 
{
	protected function setUp() {
		System_Locator_TableLocator::unsetInstance();
	}
	
	protected function tearDown() {
		System_Locator_TableLocator::unsetInstance();
	}

	/**
	 * @covers System_Locator_TableLocator::getInstance
	 */
	public function testGetInstance() {
		$locator = System_Locator_TableLocator::getInstance();
		self::assertNotNull($locator);
		self::assertType('System_Locator_TableLocator', $locator);

		self::assertSame($locator, System_Locator_TableLocator::getInstance());
	}

	/**
	 * @covers System_Locator_TableLocator::unsetInstance
	 */
	public function testUnsetInstance() {
		$locator = System_Locator_TableLocator::getInstance();
		System_Locator_TableLocator::unsetInstance();

		self::assertNotSame($locator, System_Locator_TableLocator::getInstance());
	}

	/**
	 * @covers System_Locator_TableLocator::setInstance
	 */
	public function testSetInstance() {
		$locator = System_Locator_TableLocator::getInstance();
		System_Locator_TableLocator::unsetInstance();
		System_Locator_TableLocator::setInstance($locator);

		self::assertSame($locator, System_Locator_TableLocator::getInstance());
	}

	/**
	 * @covers System_Locator_TableLocator::setClassPrefix
	 * @covers System_Locator_TableLocator::getClassPrefix
	 */
	public function testSetGetClassPrefix() {
		self::assertGetterAndSetter(System_Locator_TableLocator::getInstance(), 'ClassPrefix', 'Other_Model_Table_');
	}

	/**
	 * @covers System_Locator_TableLocator::getTableClass
	 */
	public function testGetTableClass() {
		$locator = System_Locator_TableLocator::getInstance();
		self::assertEquals('Model_Table_Table', $locator->getTableClass('Table'));
	}

	/**
	 * @covers System_Locator_TableLocator::get
	 */
	public function testGetNoSuchTable() {
		$oldErrorReporting = error_reporting(0);
		try {
			System_Locator_TableLocator::getInstance()->get('NoTable');
			self::fail('Exception excepted');
		} catch (System_Exception $e) {}
		error_reporting($oldErrorReporting);
	}

	/**
	 * @covers System_Locator_TableLocator::get
	 * @covers System_Locator_TableLocator::set
	 */
	public function testSetGet() {
		$locator = System_Locator_TableLocator::getInstance();
		$table = new System_Db_Table();

		$locator->set('a', $table);

		self::assertSame($table, $locator->get('a'));
	}

	/**
	* @covers System_Locator_TableLocator::get
	 */
	public function testGet() {
		$locator = System_Locator_TableLocator::getInstance();
		$locator->setClassPrefix('System_Db_');
		self::assertNotNull($locator->get('Table'));
	}
}
