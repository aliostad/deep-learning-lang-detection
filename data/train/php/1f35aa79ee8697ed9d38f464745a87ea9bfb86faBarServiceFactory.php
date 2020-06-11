<?php

namespace MyModule\Factory;

use MyModule\Service\BarService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class BarServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return BarService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new BarService(
            $serviceLocator->get('MyModule\Service\FooService')
        );
    }
}
