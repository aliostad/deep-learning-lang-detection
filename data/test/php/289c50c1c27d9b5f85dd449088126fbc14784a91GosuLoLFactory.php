<?php namespace Scraper\Casters\Factory;

use Scraper\Casters\GosuLoLCaster;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GosuLoLFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $matchesService = $serviceLocator
            ->get('MatchesService');

        $teamService = $serviceLocator
            ->get('TeamService');

        $sportService = $serviceLocator
            ->get('SportService');

        $eventService = $serviceLocator
            ->get('EventService');

        $caster = new GosuLoLCaster(
            $matchesService,
            $teamService,
            $sportService,
            $eventService
        );

        return $caster;
    }
}