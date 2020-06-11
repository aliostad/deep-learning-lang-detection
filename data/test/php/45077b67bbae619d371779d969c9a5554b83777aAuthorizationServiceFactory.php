<?php

namespace Admin\Service\Factory;

use Admin\Service\AuthorizationService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthorizationServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $services)
    {
        $serviceLocator = $services->get('ServiceManager');

        $authorizationService = new AuthorizationService();
        $authorizationService->setServiceManager($serviceLocator);
        $authorizationService->setSessionManager($serviceLocator->get('Session'));
        $authorizationService->setDbalConn($serviceLocator->get('doctrine.connection.orm_default'));

        return $authorizationService;
    }
}