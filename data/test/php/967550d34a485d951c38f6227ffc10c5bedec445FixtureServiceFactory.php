<?php

namespace UsaRugbyStats\DataImporter\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class FixtureServiceFactory implements FactoryInterface
{
    /**
     * Create service.
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return SyncTeam
     */
    public function createService(ServiceLocatorInterface $sm)
    {
        $config = $sm->get('Config')['usarugbystats']['data-importer']['fixtures'];
        $service = new FixtureService($config);

        return $service;
    }
}
