<?php

namespace Application\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AccountServiceFactory
extends ApplicationServiceFactory
implements FactoryInterface
{
	public function createService (ServiceLocatorInterface $serviceLocator)
	{
		if (!parent::createService($serviceLocator))
		{
			throw new \Exception ("Object manager is missing.");
		}
		$authenticationService = $serviceLocator->get('Zend\Authentication\AuthenticationService');
		if ($authenticationService == null)
		{
			throw new \Exception ("Authentication service is missing.");
		}
		return new AccountService ($this->getObjectManager( ), $authenticationService);	
	}
}