<?php
namespace PtgBase\Service;

use Zend\ServiceManager\ServiceManagerAwareInterface,
    Zend\ServiceManager\ServiceManager;

abstract class ServiceAbstract implements ServiceManagerAwareInterface
{
    /**
     * @var ServiceManager
     */
    protected $serviceManager;
    
    /**
     * Retrieve service manager instance
     *
     * @return ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }

    /**
     * Set service manager instance
     *
     * @param ServiceManager $serviceManager
     * @return ServiceAbstract
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        
        return $this;
    }
}