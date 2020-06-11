<?php

/**
 * namespace definition and usage
 */
namespace Pizza\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Admin controller factory
 * 
 * Generates the Pizza controller object
 * 
 * @package    Pizza
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
        $sm         = $serviceLocator->getServiceLocator();
        $service    = $sm->get('Pizza\Service\Pizza');
        $controller = new AdminController();
        $controller->setPizzaService($service);
        return $controller;
    }
}
