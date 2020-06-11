<?php

/**
 * namespace definition and usage
 */
namespace User\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * User controller factory
 * 
 * Generates the User controller object
 * 
 * @package    User
 */
class UserControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service    = $serviceLocator->getServiceLocator()->get('User\Service\User');
        $controller = new UserController();
        $controller->setUserService($service);
        return $controller;
    }
}
