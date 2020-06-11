<?php

namespace Application\Factory\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Service\IndexService;

class IndexServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {

        $service = new IndexService($serviceLocator->get('Application\Common\Service\EntityManagerHolder'));
        $service->setEntityManager($serviceLocator->get('Doctrine\ORM\EntityManager'));

        return $service;
    }

}