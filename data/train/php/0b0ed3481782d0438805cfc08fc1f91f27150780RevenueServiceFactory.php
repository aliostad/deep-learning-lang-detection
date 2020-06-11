<?php

namespace DtlFinancial\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use DtlFinancial\Service\RevenueService;

class RevenueServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new RevenueService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setRepository('DtlFinancial\Entity\Revenue');
        return $service;
    }
}
