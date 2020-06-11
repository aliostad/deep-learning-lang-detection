<?php

namespace Financial\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Financial\Service\RevenueService;

class RevenueServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new RevenueService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setRepository('Financial\Entity\Revenue');
        return $service;
    }
}
