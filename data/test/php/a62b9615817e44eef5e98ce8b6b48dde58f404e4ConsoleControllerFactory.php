<?php

namespace Server\Controller;

use Server\Service\ServerService;
use Server\Service\ServerServiceFactory;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ConsoleControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $controllerManager)
	{
		/** @var ServiceLocatorInterface $serviceLocator */
		$serviceLocator = $controllerManager->getServiceLocator();

		/** @var ServerService $serverService */
		$serverService = $serviceLocator->get(ServerService::class);

		return new ConsoleController($serverService);
	}
}
