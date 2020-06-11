<?php

namespace Config\Factory\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Config\Service\ConfigService;

class ConfigServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {

        $service = new ConfigService($serviceLocator->get('Application\Common\Service\EntityManagerHolder'));
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }

}
