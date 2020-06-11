<?php 
namespace XOUser\Factory\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use XOUser\Service\UserService;

class UserServiceFactory implements FactoryInterface
{
	/**
	 * Create service
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return mixed
	 */	
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$userService = new UserService();
		$userService->setServiceManager($serviceLocator);
		return $userService;
	}
}