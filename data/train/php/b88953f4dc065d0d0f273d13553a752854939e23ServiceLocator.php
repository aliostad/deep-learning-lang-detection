<?php

namespace PHPEE\Pattern;

/**
 * ServiceLocator
 */
class ServiceLocator {

    private static $_instance = null;

    /**
     * Service storage pool
     */
    private $_registeredServicePool = array();

    /**
     * @brief get ServiceLocator instance
     * @return ServiceLocator
     */
    public static function getInstance() {
        if (! self::$_instance instanceof self) {
            self::$_instance = new self();
        }
        return self::$_instance;
    }

    /**
     * @brief get Service object
     * @param $ServiceName
     * @return $service
     */
    public function get($serviceName) {

        if (!$this->_isRegistedService($serviceName)) {
            $Service = &$this->createService($serviceName);
            $this->_registerService($serviceName,$Service);
        }

        return $this->_registeredServicePool[$serviceName];
    }

    /**
     * @brief register Service
     * @param $serviceName
     * @param $Service
     */
    private function _register($serviceName, $Service) {
        $this->_registeredServicePool[$serviceName] = $Service;
    }

    /**
     * @brief unregister Service
     * @param $serviceName
     */
    private function _unregisterService($serviceName) {
        unset($this->_registeredServicePool[$serviceName]);
    }

    /**
     * 判断Service是否注册过
     * @param $serviceName
     * @return bool
     */
    private function _isRegistedService($serviceName) {
        return isset($this->_registeredServicePool[$serviceName])
        && $this->_registeredServicePool[$serviceName] != null;
    }

    abstract protected function createService($serviceName);

}
