<?php
// Filename /module/FuelStation/src/FuelStation/Factory/FuelStationServiceFactory.php

namespace FuelStation\Factory;

use FuelStation\Service\StationService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class StationServiceFactory implements FactoryInterface
{
    /**
     * Create Service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new StationService(
            $serviceLocator->get('FuelStation\Mapper\StationMapperInterface')
        );
    }
}
