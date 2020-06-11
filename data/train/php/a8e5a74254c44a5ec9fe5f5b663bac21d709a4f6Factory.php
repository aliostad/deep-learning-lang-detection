<?php

namespace ZFS\DomainModel\Service;

use ZFS\DomainModel\Service;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class Factory
 * @package ZFS\DomainModel\Service
 */
class Factory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return Service
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new Service();
        $service->setServiceLocator($serviceLocator);

        return $service;
    }
}
