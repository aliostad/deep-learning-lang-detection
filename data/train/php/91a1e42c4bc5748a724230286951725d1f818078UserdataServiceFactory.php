<?php

namespace User\Factory;

use User\Service\UserdataService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class UserdataServiceFactory implements FactoryInterface{
    /**
     * Create service.
     * 
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator) {
        return new UserdataService(
                $serviceLocator->get('User\Mapper\UserdataMapperInterface')
                );
    }
}

