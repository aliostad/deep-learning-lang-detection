<?php

namespace ZendExtensions\Entity;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceLocatorAwareEntity implements ServiceLocatorAwareInterface
{
    protected $sm;

    /**
     * Set the service locator
     *
     * @param ServiceLocatorInterface $sm
     *
     * @return void
     */
    public function setServiceLocator(ServiceLocatorInterface $sm)
    {
        $this->sm = $sm;
    }

    /**
     * Get the service locator
     *
     * @return ServiceLocator ServiceLocator instance
     */
    public function getServiceLocator()
    {
        return $this->sm;
    }
}