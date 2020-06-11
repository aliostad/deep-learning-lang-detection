<?php
// Filename: DeleteControllerFactory.php

namespace Login\Factory;

use Login\Controller\DeleteController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class DeleteControllerFactory implements FactoryInterface
{
	/**
	 * Create service
	 */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
    	$realServiceLocator = $serviceLocator->getServiceLocator();
    	$userService = $realServiceLocator->get('Login\Service\UserServiceInterface');
    	return new DeleteController($userService);
    }
    
}