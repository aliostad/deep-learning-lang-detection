<?php

namespace UsaRugbyStats\Competition\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class PlayerStatisticsServiceFactory implements FactoryInterface
{
    /**
     * Create service.
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return Authentication
     */
    public function createService(ServiceLocatorInterface $sm)
    {
        $service = new PlayerStatisticsService();
        $service->setCompetitionMatchService($sm->get('usarugbystats_competition_competition_match_service'));

        return $service;
    }
}
