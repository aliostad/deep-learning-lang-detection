<?php

namespace Application\Service\Registration\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Service\Registration\Registration as RegistrationService;

/**
 * @author Mihail
 */
class Registration implements FactoryInterface
{

	/**
	 * Create service
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return mixed
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$objectManager = $serviceLocator->get('DoctrineORMEntityManager');
		$service = new RegistrationService($objectManager);
		return $service;
	}

}