<?php

namespace Axon\Core\Service;

trait ServiceManagerAwareTrait
{

    protected $_serviceManager;

    /**
     * Set service manager.
     * @param ServiceManagerInterface $serviceManager
     * @return \Axon\Core\Service\ServiceManagerTrait
     */
    public function setServiceManager(ServiceManagerInterface $serviceManager)
    {
        $this->_serviceManager = $serviceManager;
        return $this;
    }

    /**
     * Get service manager.
     * @return ServiceManagerInterface
     */
    public function getServiceManager()
    {
        if (!isset($this->_serviceManager)) {
            throw new ServiceException("Missing service manager instance");
        }
        return $this->_serviceManager;
    }

}
