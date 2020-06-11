<?php

namespace Admin\Service\Factory;

use Admin\Service\AuthService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Doctrine\DBAL\DriverManager;
use Doctrine\DBAL\Configuration;

class AuthServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $services)
    {
        $serviceLocator = $services->get('ServiceManager');

        $authService = new AuthService();
        $authService->setSessionManager($serviceLocator->get('Session'));
        $authService->setDbalConn($serviceLocator->get('doctrine.connection.orm_default'));

        return $authService;
    }
}