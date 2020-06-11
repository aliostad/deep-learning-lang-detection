<?php

namespace Admin\Factory;

use Admin\Controller\WriteController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class WriteControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$realServiceLocator = $serviceLocator->getServiceLocator();
		$colisService = $realServiceLocator->get('Admin\Service\ColisServiceInterface');
		$colisInsertForm = $realServiceLocator->get('FormElementManager')->get('Admin\Form\ColisForm');
		
		return new WriteController($colisService, $colisInsertForm);
	}	
}
