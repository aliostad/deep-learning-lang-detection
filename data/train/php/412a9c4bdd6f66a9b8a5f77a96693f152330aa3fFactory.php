<?php

namespace Application\PluginManager;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;

class Factory implements FactoryInterface
{
    /**
     * {@inheritdoc}
     * @return ServiceLocatorInterface
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $pluginManager = new ServiceManager;
        /** @var ServiceManager $serviceLocator */
        $pluginManager->addPeeringServiceManager($serviceLocator);

        return $pluginManager;
    }
}
