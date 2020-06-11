<?php
/**
 * ARTEMIS-IA Office copyright message placeholder.
 *
 * @category    Calendar
 *
 * @author      Andre Hebben <andre.hebben@artemis-ia.eu>
 * @copyright   Copyright (c) 2008-2016 ARTEMIS-IA Office (https://artemis-ia.eu)
 */

namespace Project\Navigation\Factory;

use Affiliation\Service\AffiliationService;
use Project\Navigation\Service\AchievementNavigationService;
use Project\Service\AchievementService;
use Project\Service\ProjectService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * NodeService.
 *
 * this is a wrapper for node entity related services
 */
class AchievementNavigationServiceFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return AchievementNavigationService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $achievementNavigationService = new AchievementNavigationService();
        $achievementNavigationService->setTranslator($serviceLocator->get('viewhelpermanager')->get('translate'));
        /**
         * @var $projectService ProjectService
         */
        $projectService = $serviceLocator->get(ProjectService::class);
        $achievementNavigationService->setProjectService($projectService);
        /**
         * @var $affiliationService AffiliationService
         */
        $affiliationService = $serviceLocator->get(AffiliationService::class);
        $achievementNavigationService->setAffiliationService($affiliationService);
        /**
         * @var $achievementService AchievementService
         */
        $achievementService = $serviceLocator->get(AchievementService::class);
        $achievementNavigationService->setAchievementService($achievementService);
        $application = $serviceLocator->get('application');
        $achievementNavigationService->setRouteMatch($application->getMvcEvent()->getRouteMatch());
        $achievementNavigationService->setRouter($application->getMvcEvent()->getRouter());
        /*
         * @var Navigation
         */
        $navigation = $serviceLocator->get('navigation');
        $achievementNavigationService->setNavigation($navigation);

        return $achievementNavigationService;
    }
}
