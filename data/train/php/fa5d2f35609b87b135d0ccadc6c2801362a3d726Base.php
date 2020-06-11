<?php

namespace Andreatta\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface,
	Zend\ServiceManager\ServiceLocatorInterface;

class Base implements ServiceLocatorAwareInterface
{
	
	/**
     * @var ServiceLocatorInterface
     */
    protected $serviceLocator;
	
	/**
     * Set serviceManager instance
     *
     * @param  ServiceLocatorInterface $serviceLocator
     * @return void
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {

        $this->serviceLocator = $serviceLocator;

        return $this;

    }

    /**
     * Retrieve serviceManager instance
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {

        return $this->serviceLocator;

    }
	
}

?>
