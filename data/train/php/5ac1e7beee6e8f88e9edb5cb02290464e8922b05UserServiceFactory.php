<?php

namespace SampleService\Service\Service;

use SampleService\Service\UserService;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Stdlib\Hydrator\ClassMethods;

class UserServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $userMapper = $serviceLocator->get('SampleService\Mapper\UserMapper');

        $service = new UserService();
        $service->setUserMapper($userMapper);

        return $service;
    }
}