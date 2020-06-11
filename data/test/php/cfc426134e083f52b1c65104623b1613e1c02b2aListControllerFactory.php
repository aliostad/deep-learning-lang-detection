<?php
// Filename /module/FuelStation/src/FuelStation/Factory/ListControllerFactory.php
namespace FuelStation\Factory;

use FuelStation\Controller\ListController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ListControllerFactory implements FactoryInterface
{
    /**
     * Create Service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $realServiceLocator = $serviceLocator->getServiceLocator();
        $stationService = $realServiceLocator->get('FuelStation\Service\StationServiceInterface');
        $gmapsService = $serviceLocator->getServiceLocator()->get('GMaps\Service\GoogleMap');

        return new ListController($stationService, $gmapsService);
    }
}