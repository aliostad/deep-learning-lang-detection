<?php

namespace Application\Service\ResetPassword\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Service\ResetPassword\ResetPassword as ResetPasswordService;

/**
 * @author Mihail
 */
class ResetPassword implements FactoryInterface
{

	/**
	 * Create service
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return mixed
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$objectManager = $serviceLocator->get('DoctrineORMEntityManager');
		$service = new ResetPasswordService($objectManager);
		return $service;
	}

}