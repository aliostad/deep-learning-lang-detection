<?php

namespace Vu\Zf2TestExtensions\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;

/**
 * Class AbstractServiceLocatorAwareService
 *
 * @package Vu\Zf2TestExtensions\Service
 *
 * <h2>This abstract class implements the interface for simplification</h2>
 */
abstract class AbstractServiceLocatorAwareService implements ServiceLocatorAwareInterface {

    /**
     * @var ServiceManager
     */
    private $service_locator;

    /**
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
        $this->service_locator = $serviceLocator;
    }

    /**
     * @return ServiceManager
     */
    public function getServiceLocator() {
        return $this->service_locator;
    }

    /**
     * @param string $service
     * @return array|object
     */
    public function getService($service){
        return $this->getServiceLocator()->get($service);
    }
}