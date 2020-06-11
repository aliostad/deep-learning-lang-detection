<?php

namespace ContactServices;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;
use Sql\SqlService;
use Zend\Stdlib\Hydrator\ClassMethods;

class ContactServiceFactory implements FactoryInterface
{
    /**
     * Inject dependencies into contact service
     *
     * @param ServiceLocatorInterface $services
     * @return ContactService
     */
    public function createService(ServiceLocatorInterface $services)
    {
        $service = new ContactService();
        $service->setSqlService($services->get(SqlService::class));
        $service->setHydrator(new ClassMethods());
        return $service;
    }
}