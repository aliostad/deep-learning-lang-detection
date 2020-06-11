<?php

namespace MxcLayoutScheme\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class LayoutSchemeServiceFactory implements FactoryInterface {
    
    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new LayoutSchemeService;
        // register service with the layoutScheme controller plugin
        $serviceLocator->get('ControllerPluginManager')->get('layoutScheme')->setLayoutSchemeService($service);
        return $service;        
    }
}