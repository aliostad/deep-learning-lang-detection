<?php

namespace Lunar\Service;

use Zend\ServiceManager\ServiceManagerAwareInterface,
    Zend\ServiceManager\ServiceManager;

class AbstractService
    implements ServiceManagerAwareInterface
{
    /** @var ServiceManager */
    protected $serviceManager;

    /**
     * Set service manager.
     *
     * @param ServiceManager $serviceManager
     * @return AbstractService
     */
    public function setServiceManager (ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        return $this;
    }

    /**
     * Returns the service manager if available.
     * @return ServiceManager
     * @throws RuntimeException if no manager is available
     */
    public function getServiceManager ()
    {
        if ($this->serviceManager === null) {
            throw new RuntimeException ('No service manager available');
        }

        return $this->serviceManager;
    }
}

