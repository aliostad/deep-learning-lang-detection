<?php

namespace User\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use User\Service\UserService;

class UserServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param  ServiceLocatorInterface|ServiceManager $serviceLocator
     * @return UserService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new UserService($serviceLocator);
    }

}
