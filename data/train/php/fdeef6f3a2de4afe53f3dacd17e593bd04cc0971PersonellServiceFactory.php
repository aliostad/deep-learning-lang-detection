<?php
namespace Techtree\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class PersonellServiceFactory implements FactoryInterface
{
    /**
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return \Techtree\Service\PersonellService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $tick   = $serviceLocator->get('Core\Service\Tick');
        $logger = $serviceLocator->get('logger');

        $tables = array();
        $tables['personell']        = $serviceLocator->get('Techtree\Table\PersonellTable');
        $tables['personell_costs']  = $serviceLocator->get('Techtree\Table\PersonellCostTable');
        $tables['colony_personell'] = $serviceLocator->get('Techtree\Table\ColonyPersonellTable');
        $tables['colony_buildings'] = $serviceLocator->get('Techtree\Table\ColonyBuildingTable');
        $tables['locked_actionpoints'] = $serviceLocator->get('Techtree\Table\ActionPointTable');
        $tables['colonies'] = $serviceLocator->get('Colony\Table\ColonyTable');

        $services = array();
        $services['resources'] = $serviceLocator->get('Resources\Service\ResourcesService');
        #$services['buildings'] = $serviceLocator->get('Techtree\Service\BuildingService');
        #$services['galaxy']    = $serviceLocator->get('Galaxy\Service\Gateway');

        $service = new PersonellService($tick, $tables, $services);
        $service->setLogger($logger);
        return $service;
    }
}