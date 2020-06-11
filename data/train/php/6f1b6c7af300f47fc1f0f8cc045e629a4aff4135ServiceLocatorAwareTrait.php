<?php

namespace InfinityBase\ServiceManager;

use Zend\ServiceManager\ServiceLocatorInterface;

trait ServiceLocatorAwareTrait
{

    /**
     * @var ServiceLocatorInterface
     */
    private $_serviceLocator;

    /**
     * Retrieve the service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->_serviceLocator;
    }

    /**
     * Set the service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return AbstractForm
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->_serviceLocator = $serviceLocator;
        return $this;
    }

}

