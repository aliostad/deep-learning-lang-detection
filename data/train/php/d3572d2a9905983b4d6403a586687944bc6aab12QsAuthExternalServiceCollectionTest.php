<?php

Yii::import('ext.qs.lib.web.auth.external.*');

/**
 * Test case for the extension "ext.qs.lib.web.auth.external.QsAuthExternalServiceCollection".
 * @see QsAuthExternalServiceCollection
 */
class QsAuthExternalServiceCollectionTest extends CTestCase {
	/**
	 * Creates test external auth service instance.
	 * @return QsAuthExternalService external auth service instance.
	 */
	protected function createTestAuthExternalService() {
		return $this->getMock('QsAuthExternalService', array('authenticate'));
	}

	// Tests :

	public function testSetGet() {
		$serviceHub = new QsAuthExternalServiceCollection();

		$services = array(
			'testService1' => $this->createTestAuthExternalService(),
			'testService2' => $this->createTestAuthExternalService(),
		);
		$serviceHub->setServices($services);
		$this->assertEquals($services, $serviceHub->getServices(), 'Unable to setup services!');
	}

	/**
	 * @depends testSetGet
	 */
	public function testGetServiceById() {
		$serviceHub = new QsAuthExternalServiceCollection();

		$serviceId = 'testServiceId';
		$service = $this->createTestAuthExternalService();
		$services = array(
			$serviceId => $service
		);
		$serviceHub->setServices($services);

		$this->assertEquals($service, $serviceHub->getService($serviceId), 'Unable to get service by id!');
	}

	/**
	 * @depends testGetServiceById
	 */
	public function testCreateService() {
		$serviceHub = new QsAuthExternalServiceCollection();

		$serviceId = 'testServiceId';
		$serviceClassName = get_class($this->createTestAuthExternalService());
		$services = array(
			$serviceId => array(
				'class' => $serviceClassName
			)
		);
		$serviceHub->setServices($services);

		$service = $serviceHub->getService($serviceId);
		$this->assertTrue(is_object($service), 'Unable to create service by config!');
		$this->assertTrue(is_a($service, $serviceClassName), 'Service has wrong class name!');
	}

	/**
	 * @depends testSetGet
	 */
	public function testHasService() {
		$serviceHub = new QsAuthExternalServiceCollection();

		$serviceName = 'testServiceName';
		$services = array(
			$serviceName => array(
				'class' => 'TestService1'
			),
		);
		$serviceHub->setServices($services);

		$this->assertTrue($serviceHub->hasService($serviceName), 'Existing service check fails!');
		$this->assertFalse($serviceHub->hasService('unExistingServiceName'), 'Not existing service check fails!');
	}
}
