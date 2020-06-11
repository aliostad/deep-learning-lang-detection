<?php namespace Scraper\Casters\Factory;

use Scraper\Casters\GosuMatchCaster as Caster;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GosuMatchCaster implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $matchesService = $serviceLocator
            ->get('MatchesService');

        $teamService = $serviceLocator
            ->get('TeamService');

        $gameService = $serviceLocator
            ->get('GameService');

        $eventService = $serviceLocator
            ->get('EventService');

        $caster = new Caster(
            $matchesService,
            $teamService,
            $gameService,
            $eventService
        );

        return $caster;
    }
}