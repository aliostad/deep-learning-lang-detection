<?php
namespace Vivo\Module;

use Zend\ModuleManager\ModuleEvent as ZendModuleEvent;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * ModuleEvent
 */
class ModuleEvent extends ZendModuleEvent
{
    /**
     * Service Locator
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;

    /**
     * Sets service locator
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * Returns service locator
     * @return \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}
