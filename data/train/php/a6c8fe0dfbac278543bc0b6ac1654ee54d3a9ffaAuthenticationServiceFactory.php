<?php

namespace SpiffyUser\Authentication;

use Zend\Authentication\AuthenticationService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthenticationServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return AuthenticationService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var \DoctrineModule\Authentication\Storage\ObjectRepository $storage */
        $adapter = $serviceLocator->get('doctrine.authenticationadapter.orm_default');
        $storage = $serviceLocator->get('doctrine.authenticationstorage.orm_default');

        return new AuthenticationService($storage, $adapter);
    }
}