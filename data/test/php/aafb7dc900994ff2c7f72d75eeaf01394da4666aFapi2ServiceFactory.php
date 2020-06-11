<?php

namespace Fapi2\Factory;

use Fapi2\Service\Fapi2Service;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class Fapi2ServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $adapter = $serviceLocator->get('fapi2Adapter');

        $service = new Fapi2Service;
        $service->setAdapter($adapter);
        return $service;
    }
}