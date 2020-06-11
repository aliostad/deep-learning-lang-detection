<?php
namespace ApptSimpleAuth\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use ApptSimpleAuth\Service\Options\Auth as Options;

use ApptSimpleAuth\AuthService;

class AuthServiceFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return AuthService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $options = Options::init($serviceLocator);

        $authenticationService = $serviceLocator->get('doctrine.authenticationservice.' . $options->getDocumentManager());
        $aclService = $serviceLocator->get('appt.simple_auth.acl');

        $auth = new AuthService($aclService, $authenticationService);

        return $auth;
    }
}