<?php

/**
 * namespace definition and usage
 */
namespace User\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Admin controller factory
 * 
 * Generates the Admin controller object
 * 
 * @package    User
 */
class AdminControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service    = $serviceLocator->getServiceLocator()->get('User\Service\User');
        $controller = new AdminController();
        $controller->setUserService($service);
        return $controller;
    }
}
