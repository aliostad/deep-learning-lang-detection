<?php

namespace User\Service;

class AuthenticationServiceFactory implements \Zend\ServiceManager\FactoryInterface
{
    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return \Zend\Authentication\AuthenticationService
     */
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $authStorage = new \Zend\Authentication\Storage\Session('auth');
        return new \Zend\Authentication\AuthenticationService($authStorage);
    }
}
