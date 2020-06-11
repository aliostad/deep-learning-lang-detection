<?php

namespace SpiffyUser\Extension;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthenticationFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return Authentication
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var \Zend\Authentication\AuthenticationService $authService */
        $authService = $serviceLocator->get('Zend\Authentication\AuthenticationService');

        return new Authentication($authService);
    }
}