<?php

namespace Application\Initializer;

use Application\Service\AuthorizationServiceAwareInterface;
use Zend\ServiceManager\InitializerInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthorizationServiceInitializer implements InitializerInterface
{
    /**
     * @inheritdoc
     */
    public function initialize($instance, ServiceLocatorInterface $serviceLocator)
    {
        if ($instance instanceof AuthorizationServiceAwareInterface) {
            $authorizationService = $serviceLocator->get('ZfcRbac\Service\AuthorizationService');
            $instance->setAuthorizationService($authorizationService);
        }
    }
}
