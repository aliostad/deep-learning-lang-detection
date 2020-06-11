<?php
namespace BqCore\Service;

use Zend\ServiceManager\ServiceLocatorInterface;

abstract class AbstractService implements ServiceInterface
{
    protected $serviceLocator;

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $this->setServiceLocator($serviceLocator);
        return $this;
    }

    public function getServiceLocator() {
        return $this->serviceLocator;
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }
}
