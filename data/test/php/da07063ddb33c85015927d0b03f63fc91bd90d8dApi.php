<?php
namespace Prison\Service;

use Zend\Mvc\MvcEvent;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;

class Api implements ServiceLocatorAwareInterface
{
    protected $event;
    protected $service;

    public function __construct()
    {}

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->service = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->service;
    }

    /**
     * @param MvcEvent $e
     */
    public function setEvent(MvcEvent $e)
    {
        $this->event = $e;
    }

    /**
     * @return MvcEvent
     */
    public function getEvent()
    {
        return $this->event;
    }
}