<?php

namespace Cli\Controller;

use Cli\Service\AuthService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ExampleControllerFactory implements FactoryInterface
{
    /**
     * Create ExampleController
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return ExampleController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $authService = $this->getAuthService($serviceLocator);

        $exampleController = new ExampleController;
        $exampleController->setAuthService($authService);

        return $exampleController;
    }

    /**
     * Get the AuthService from service locator
     *
     * @param ServiceLocatorInterface $serviceLocatorInterface
     *
     * @return AuthService
     */
    private function getAuthService(ServiceLocatorInterface $serviceLocatorInterface)
    {
        /** @var AuthService $authService */
        $authService = $serviceLocatorInterface->getServiceLocator()->get('Cli\Service\AuthService');

        return $authService;
    }
}
