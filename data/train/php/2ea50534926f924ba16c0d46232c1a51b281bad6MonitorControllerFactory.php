<?php

namespace Admin\Factory;

use Admin\Controller\MonitorController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class MonitorControllerFactory implements FactoryInterface
{

	public function createService(ServiceLocatorInterface $serviceLocator)
	{	    
		$realServiceLocator = $serviceLocator->getServiceLocator();
		
		$colisService = $realServiceLocator->get('Admin\Service\ColisServiceInterface');
		 
		return new MonitorController($colisService);
	}
	
	
}

