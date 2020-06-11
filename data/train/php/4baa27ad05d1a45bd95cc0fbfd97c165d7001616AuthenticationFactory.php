<?php

namespace TeaAdmin\Authentication;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthenticationFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new \Zend\Authentication\AuthenticationService();
        $service->setAdapter($serviceLocator->get('TeaAdmin\Authentication\Adapter'));
        $service->setStorage($serviceLocator->get('TeaAdmin\Authentication\Storage'));
        
        return $service;
    }
}