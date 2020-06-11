<?php

namespace Eva\ServiceManager;

trait ServiceManagerAwareTrait
{
    /**
     * @var ServiceManager
     */
    private $serviceManager;

    /**
     * @param ServiceManager $serviceManager
     * @return $this
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;

        return $this;
    }

    /**
     * @return ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }
} 