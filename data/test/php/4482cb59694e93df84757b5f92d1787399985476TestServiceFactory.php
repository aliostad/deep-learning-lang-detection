<?php

namespace Mod1\Factories;

use Mod1\Service\TestService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class TestServiceFactory implements FactoryInterface
{

	/**
	 * Create service
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return mixed
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$service = new TestService();

		$service->setVar1('var1 равен ...');
		$service->setVar2('var2 равен ...');

		return $service;
	}
}