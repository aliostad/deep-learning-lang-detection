<?php

namespace Transmove\Move;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;

class OperationManager implements ServiceLocatorInterface, ServiceLocatorAwareInterface
{
    /**
     * @var ServiceManager
     */
    private $serviceLocator;

    /**
     * @var array
     */
    private $config;

    public function __construct(array $config)
    {
        $this->config = $config;
    }

    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator =$serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    public function get($name)
    {
        $opServiceName = $this->config[$name];
       $opService = $this->serviceLocator->get($opServiceName);

        return $opService;
    }

    public function has($name)
    {
        return isset($this->config[$name]);
    }
}