<?php
namespace Techtree\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ResearchServiceFactory implements FactoryInterface
{
    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return ResearchService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $tick   = $serviceLocator->get('Core\Service\Tick');
        $logger = $serviceLocator->get('logger');

        $tables = array();
        $tables['researches']        = $serviceLocator->get('Techtree\Table\ResearchTable');
        $tables['research_costs']    = $serviceLocator->get('Techtree\Table\ResearchCostTable');
        $tables['colony_buildings']  = $serviceLocator->get('Techtree\Table\ColonyBuildingTable');
        $tables['colony_researches'] = $serviceLocator->get('Techtree\Table\ColonyResearchTable');
        $tables['colonies']          = $serviceLocator->get('Colony\Table\ColonyTable');

        $services = array();
        $services['resources'] = $serviceLocator->get('Resources\Service\ResourcesService');
        #$services['buildings']    = $serviceLocator->get('Techtree\Service\BuildingService');
        $services['personell']    = $serviceLocator->get('Techtree\Service\PersonellService');

        $service = new ResearchService($tick, $tables, $services);
        $service->setLogger($logger);
        return $service;
    }
}