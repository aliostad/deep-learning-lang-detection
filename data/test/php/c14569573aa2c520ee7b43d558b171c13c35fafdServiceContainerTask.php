<?php
App::uses('ServiceContainer', 'ServiceContainer.Lib/Service/Container');

class ServiceContainerTask extends Shell {
    private $__serviceContainer;

    public function execute() {}

    public function get($serviceName) {
        return $this->__getServiceContainer()->getService($serviceName);
    }

    /**
     * @return ServiceContainer
     */
    private function __getServiceContainer() {
        if (is_null($this->__serviceContainer)) {
            $this->__serviceContainer = new ServiceContainer();
        }

        return $this->__serviceContainer;
    }
}