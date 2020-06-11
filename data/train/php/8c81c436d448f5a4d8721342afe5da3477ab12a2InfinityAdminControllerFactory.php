<?php
/**
 * Infinity Framework 
 *
 * Framework library Controller Factory
 * @version 1.0.0  
 */

namespace Infinity\Factory;

use Infinity\Controller\InfinityAdminController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class InfinityAdminControllerFactory implements FactoryInterface
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
        $dataService = $realServiceLocator->get('Infinity\Service\DataServiceInterface');

        return new InfinityAdminController( $dataService );
    }

}