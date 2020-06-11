<?php

namespace Openstore\Catalog;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class PriceManagerFactory implements FactoryInterface
{
    /**
     *
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return \Openstore\Catalog\PriceManager
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $configuration = $serviceLocator->get('Openstore\Configuration');
        $adapter = $serviceLocator->get('Zend\Db\Adapter\Adapter');

        $service = new PriceManager($configuration, $adapter);
        $service->setServiceLocator($sl);
        return $service;
    }
}
