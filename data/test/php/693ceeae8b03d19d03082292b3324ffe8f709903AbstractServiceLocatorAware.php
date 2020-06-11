<?php
namespace FdlGatewayManager;

use Zend\ServiceManager;

abstract class AbstractServiceLocatorAware implements ServiceManager\ServiceLocatorAwareInterface
{
    /**
     * @var Zend\ServiceManager\ServiceManager
     */
    protected $serviceLocator;

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceManager\ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
}
