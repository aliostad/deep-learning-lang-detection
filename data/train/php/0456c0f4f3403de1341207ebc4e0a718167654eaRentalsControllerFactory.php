<?php

/**
 * namespace definition and usage
 */
namespace Rentals\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Rentals controller factory
 * 
 * Generates the Rentals controller object
 * 
 * @package    Rentals
 */
class RentalsControllerFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm         = $serviceLocator->getServiceLocator();
        $service    = $sm->get('Rentals\Service\Rentals');
        $controller = new RentalsController();
        $controller->setRentalsService($service);
        return $controller;
    }
}
