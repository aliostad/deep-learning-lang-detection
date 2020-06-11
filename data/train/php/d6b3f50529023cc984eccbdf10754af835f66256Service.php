<?php

namespace GoalioModuleInstaller\Command;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\Exception;

class Service implements CommandInterface, ServiceLocatorAwareInterface {

    /**
     * @var CommandManager
     */
    protected $serviceLocator;

    protected $service = null;
    protected $method = null;

    public function __construct($options) {

        if(!isset($options['service']) || !isset($options['method'])) {
            throw new Exception\InvalidArgumentException('Missing service or method name for Service command');
        }

        $this->service = $options['service'];
        $this->method  = $options['method'];
    }

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator() {
        return $this->serviceLocator;
    }


    public function execute($params) {
        $serviceLocator = $this->getServiceLocator()->getServiceLocator();

        $service = $serviceLocator->get($this->service);

        if(method_exists($service, $this->method)) {
            call_user_func(array($service, $this->method), $params, $serviceLocator);
        }
    }

}