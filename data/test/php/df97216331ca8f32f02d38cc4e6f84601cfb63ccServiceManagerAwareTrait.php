<?php

namespace Zucchi\ServiceManager;

use Traversable;
use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\ServiceManager;


trait ServiceManagerAwareTrait
{
    /**
     * @var ServiceManager
     */
    protected $serviceManager;

    /**
     * @param \Zend\ServiceManager\ServiceManager $serviceManager
     * @return ServiceManagerAwareTrait
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