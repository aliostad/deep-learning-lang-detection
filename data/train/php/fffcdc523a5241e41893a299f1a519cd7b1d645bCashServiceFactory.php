<?php

namespace Financial\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Financial\Service\CashService;

class CashServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new CashService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setRevenue('Financial\Entity\Revenue');
        $service->setExpense('Financial\Entity\Expense');
        return $service;
    }
}
