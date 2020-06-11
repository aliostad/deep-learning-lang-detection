<?php

namespace DtlService\Factory;

use DtlService\Controller\ServiceController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceControllerFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $sm = $serviceLocator->getServiceLocator();
        $entitymanager = $sm->get('doctrine.entitymanager.orm_default');
        $controller = new ServiceController();
        $controller->setEntityManager($entitymanager);
        $controller->setRepository('DtlService\Entity\Service');
        return $controller;
    }
}
