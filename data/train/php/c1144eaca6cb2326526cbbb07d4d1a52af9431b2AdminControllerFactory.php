<?php

/**
 * namespace definition and usage
 */
namespace Blog\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Admin controller factory
 * 
 * Generates the Blog controller object
 * 
 * @package    Blog
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
        $service    = $sm->get('Blog\Service\Blog');
        $controller = new AdminController();
        $controller->setBlogService($service);
        return $controller;
    }
}
