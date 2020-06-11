<?php

namespace ZfcUserRemember;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ExtensionFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return Extension
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new Extension(
            $serviceLocator->get('Zend\Authentication\AuthenticationService'),
            $serviceLocator->get('Request'),
            $serviceLocator->get('Response')
        );
    }
}