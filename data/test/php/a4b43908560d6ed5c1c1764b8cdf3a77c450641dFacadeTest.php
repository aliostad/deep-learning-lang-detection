<?php

namespace Patterns\Facade\Tests;

use Patterns\Facade\FacadeSensor;

/**
 * Facade sensor
 * @uses Patterns\Facade\FacadeSensor
 */
class FacadeTest extends \PHPUnit_Framework_TestCase
{
	/**
	 * Sensor instance
	 * @var obj $sensor
	 */
	private $sensor;

	public function setUp()
	{
		$this->sensor = new FacadeSensor;
	}

	public function testFacade()
	{
		$this->assertNotEmpty($this->sensor);
	}

	public function testFacadeController()
	{
		$controller = $this->sensor->SensorController;
		$this->assertNotEmpty($controller);
		$this->assertInstanceOf('Patterns\Facade\SensorController', $controller);
	}

	public function testFacadeFilter()
	{
		$filter = $this->sensor->SensorFilter;
		$this->assertNotEmpty($filter);
		$this->assertInstanceOf('Patterns\Facade\SensorFilter', $filter);
	}

	public function testFacadeCalibrator()
	{
		$calibrator = $this->sensor->SensorCalibrator;
		$this->assertNotEmpty($calibrator);
		$this->assertInstanceOf('Patterns\Facade\SensorCalibrator', $calibrator);
	}
}