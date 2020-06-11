<?php

namespace DtlFinancial\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use DtlFinancial\Service\ExpenseService;

class ExpenseServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new ExpenseService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setRepository('DtlFinancial\Entity\Expense');
        return $service;
    }
}
