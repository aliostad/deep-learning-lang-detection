<?php
namespace Admin\Factory;

use Admin\Controller\CommandeController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class CommandeControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{	    
		$realServiceLocator = $serviceLocator->getServiceLocator();
		$colisService = $realServiceLocator->get('Admin\Service\ColisServiceInterface');
		$userService = $realServiceLocator->get('Admin\Service\UserServiceInterface');
		return new CommandeController($colisService, $userService);
	}
}