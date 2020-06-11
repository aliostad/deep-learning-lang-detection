<?php

namespace DtlFinancial\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use DtlFinancial\Service\CashService;

class CashServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new CashService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setRevenue('DtlFinancial\Entity\Revenue');
        $service->setExpense('DtlFinancial\Entity\Expense');
        return $service;
    }
}
