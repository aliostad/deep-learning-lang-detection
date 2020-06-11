<?php

namespace DmMailerAdmin\Factory\Service;

use Zend\Authentication\AuthenticationService as AuthService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use DmMailerAdmin\Service\SessionGuard as SessionGuardService;

class SessionGuard implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return SessionGuardService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var AuthService $authService */
        $authService = $serviceLocator->get('zfcuser_auth_service');

        $sessionGuard = new SessionGuardService($authService);

        return $sessionGuard;
    }
}
