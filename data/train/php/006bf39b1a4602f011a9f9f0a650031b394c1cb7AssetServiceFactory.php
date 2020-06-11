<?php

namespace BlogServices\Asset;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Sql\SqlService;
use Zend\Stdlib\Hydrator\ClassMethods;

class AssetServiceFactory implements FactoryInterface
{
    /**
     * Inject dependencies into new asset service
     *
     * @param ServiceLocatorInterface $services
     * @return AssetService
     */
    public function createService(ServiceLocatorInterface $services)
    {
        $service = new AssetService();
        $service->setSqlService($services->get(SqlService::class));
        $service->setAssetHydrator(new ClassMethods());
        return $service;
    }
}