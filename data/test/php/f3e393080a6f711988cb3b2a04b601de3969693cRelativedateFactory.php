<?php
namespace CasasoftHelpers\View\Helper;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class RelativedateFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return EventService
     */
    public function createService(ServiceLocatorInterface $viewHelperManager)
    {
        //$serviceLocator = $viewHelperManager->getServiceLocator();
        
        $helper = new Relativedate();
        
        return $helper;
    }
}