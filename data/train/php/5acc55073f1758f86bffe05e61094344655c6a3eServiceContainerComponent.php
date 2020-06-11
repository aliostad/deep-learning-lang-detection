<?php
App::uses('Component', 'Controller');
App::uses('ServiceContainer', 'ServiceContainer.Lib/Service/Container');

class ServiceContainerComponent extends Component {
    private $__serviceContainer;

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