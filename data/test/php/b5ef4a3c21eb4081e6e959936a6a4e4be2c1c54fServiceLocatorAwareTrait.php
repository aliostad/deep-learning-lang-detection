<?php

namespace HCommons\Model;

use Zend\ServiceManager\ServiceLocatorInterface;

trait ServiceLocatorAwareTrait
{

    protected $serviceLocator;
    /**
     * Retrieve service manager instance
     *
     * @return ServiceLocator
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }    
}
