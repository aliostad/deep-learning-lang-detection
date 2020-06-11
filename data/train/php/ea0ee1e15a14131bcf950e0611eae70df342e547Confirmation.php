<?php

namespace Application\Service\Confirmation\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Service\Confirmation\Confirmation as ConfirmationService;

/**
 * @author Mihail
 */
class Confirmation implements FactoryInterface
{

	/**
	 * Create service
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return mixed
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$objectManager = $serviceLocator->get('DoctrineORMEntityManager');
		$service = new ConfirmationService($objectManager);
		return $service;
	}

}