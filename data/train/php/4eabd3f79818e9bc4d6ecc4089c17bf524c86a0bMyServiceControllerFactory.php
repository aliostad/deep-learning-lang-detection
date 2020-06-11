<?php

namespace MyService\Services;

use MyService\Controller\MyServiceController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * controller factory for setting the service
 */
class MyServiceControllerFactory implements FactoryInterface
{
    /**
     * while creating the controller service, the already existing 
     * business service is injected to the controller
     * 
     * @param \Zend\ServiceManager\ServiceLocatorInterface $services
     * @return \MyService\Controller\MyServiceController
     */
    public function createService(ServiceLocatorInterface $services)
    {
     
        $serviceManager = $services->getServiceLocator();
        
        //service call
        $service    = $serviceManager->get('business_service');
        
        $controller = new MyServiceController();
        $controller->setService($service);
        return $controller;
    }
}
