<?php
namespace XOUser\Factory\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use XOUser\Controller\SignupController;

class SignupControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$serviceManager = $serviceLocator->getServiceLocator();
		$userService = $serviceManager->get('XOUserService');
		$controller = new SignupController($userService);
		$controller->setServiceManager($serviceManager);
		return $controller;
	}
}