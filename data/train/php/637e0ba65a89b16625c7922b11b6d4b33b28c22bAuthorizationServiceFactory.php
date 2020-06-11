<?php
namespace Authorization\Service;

use Zend\ServiceManager\ServiceLocatorInterface,
    Zend\ServiceManager\FactoryInterface;
use Authentication\Service\AuthenticationService;
class AuthorizationServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return AuthorizationService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var AuthenticationService $authService */
        $authService = $serviceLocator->get('Authentication\Service\Authentication');

        return new AuthorizationService($authService);
    }

} 