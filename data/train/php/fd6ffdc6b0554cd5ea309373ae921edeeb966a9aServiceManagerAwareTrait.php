<?php

namespace WbBase\WbTrait\ServiceManager;

use \Zend\ServiceManager\ServiceManager;

/**
 * ServiceManagerAwareTrait
 *
 * @package WbBase\WbTrait\ServiceManager
 * @author  Źmicier Hryškieivič <zmicier@webbison.com>
 */
trait ServiceManagerAwareTrait
{
    /**
     * @var ServiceManager
     */
    protected $serviceManager;

    /**
     * ServiceManager setter
     *
     * @param ServiceManager $serviceManager Service manager.
     *
     * @return void
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;

        return $this;
    }

    /**
     * ServiceManager getter
     *
     * @return ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }
}
