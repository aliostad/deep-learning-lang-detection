<?php

namespace Scc\Service\Factory;

use Scc\Service\AuthAttemptService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AuthAttemptServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $em = $serviceLocator->get('Doctrine\ORM\EntityManager');
        
        $service = new AuthAttemptService();
        $service->setEntityManager($em);
        $service->setConfiguration($serviceLocator->get('Configuration'));
        
        return $service;
    }
}