<?php

namespace BsbPhingService\Options\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use BsbPhingService\Options\ServiceOptions;

class ServiceOptionsFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return ServiceOptions
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config  = $serviceLocator->get('config');
        $config  = isset($config['bsbphingservice']['service']) ? $config['bsbphingservice']['service'] : array();
        $service = new ServiceOptions($config);

        return $service;
    }
}
