<?php
namespace CloudFlare\Factory;

use CloudFlare\Controller\StatsConsoleController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class StatsConsoleControllerFactory implements FactoryInterface
{
    /**
     * @param  ServiceLocatorInterface $serviceLocator
     * @return StatsConsoleController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator();
        $statsService = $serviceLocator->get('CloudFlare\Service\StatsService');

        return new StatsConsoleController($statsService);
    }
}