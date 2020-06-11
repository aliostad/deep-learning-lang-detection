<?php

namespace Auth\Factory\Service;

use Auth\Service\TokenService;
use Auth\Service\UserService;
use Doctrine\ORM\EntityManager;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class TokenServiceFactory implements FactoryInterface{

    /**
     * Create TokenService
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return TokenService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $TokenService = new TokenService(
            $serviceLocator->get(EntityManager::class),
            $serviceLocator->get(UserService::class)
        );

        return $TokenService;
    }
}
