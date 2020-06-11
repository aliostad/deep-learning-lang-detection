<?php

namespace Financial\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Financial\Service\ExpenseService;

class ExpenseServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $service = new ExpenseService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setRepository('Financial\Entity\Expense');
        return $service;
    }
}
