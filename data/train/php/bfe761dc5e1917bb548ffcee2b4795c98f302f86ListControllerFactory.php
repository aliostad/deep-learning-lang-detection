<?php
// Filename: /module/Mspotter/src/Mspotter/Factory/ListControllerFactory.php
namespace Mspotter\Factory;

use Mspotter\Controller\ListController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ListControllerFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {

        $realServiceLocator = $serviceLocator->getServiceLocator();
        $adService        = $realServiceLocator->get('Mspotter\Service\AdServiceInterface');
        return new ListController($adService);
    }
}