<?php

namespace Core\Service;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;

abstract class Service implements ServiceManagerAwareInterface {

    protected $serviceManager;

    public function setServiceManager(ServiceManager $serviceManager) {
        $this->serviceManager = $serviceManager;
    }

    public function getServiceManager() {
        return $this->serviceManager;
    }

    public function getObjectManager() {
        $objectManager = $this->getService('Doctrine\ORM\EntityManager');
        return $objectManager;
    }

    protected function getService($service) {
        return $this->getServiceManager()->get($service);
    }

}
