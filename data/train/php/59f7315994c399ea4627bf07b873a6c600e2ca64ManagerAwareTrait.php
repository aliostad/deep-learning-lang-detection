<?php

trait CM_Service_ManagerAwareTrait {

    /** @var CM_Service_Manager */
    private $_serviceManager;

    /**
     * @param CM_Service_Manager $serviceManager
     */
    public function setServiceManager(CM_Service_Manager $serviceManager) {
        $this->_serviceManager = $serviceManager;
    }

    /**
     * @return CM_Service_Manager
     * @throws CM_Exception_Invalid
     */
    public function getServiceManager() {
        if (null === $this->_serviceManager) {
            throw new CM_Exception_Invalid('Service manager not set');
        }
        return $this->_serviceManager;
    }
}
