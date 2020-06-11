<?php

namespace AddressBook\Factory\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ContactZendDbServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /* @var $serviceLocator \Zend\ServiceManager\ServiceManager */
        $adapter = $serviceLocator->get('Zend\Db\Adapter\Adapter');
        $tableGateway = new \Zend\Db\TableGateway\TableGateway('contact', $adapter);
        $service = new \AddressBook\Service\Contact\ContactZendDbService($tableGateway);

        return $service;
    }
}
