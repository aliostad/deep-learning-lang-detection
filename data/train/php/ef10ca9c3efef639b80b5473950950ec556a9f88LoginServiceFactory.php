<?php

namespace Scc\Service\Factory;

use Scc\Service\LoginService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class LoginServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceManager) {
        $service = new LoginService();

        $em = $serviceManager->get('Doctrine\ORM\EntityManager');

        $service->setEntityManager($em);
        $service->setAuthService($serviceManager->get('Zend\Authentication\AuthenticationService'));
        $service->setAuthAttemptService($serviceManager->get('Scc\Service\AuthAttemptService'));
        return $service;
    }

}
