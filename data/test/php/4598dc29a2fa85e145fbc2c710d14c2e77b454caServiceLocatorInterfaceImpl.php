<?php

namespace Application\Util;

/**
 * 
 * @author Athlan
 *
 */
trait ServiceLocatorInterfaceImpl
{
    /**
     * 
     * @var \Zend\ServiceManager\ServiceLocatorInterface
     */
    private $serviceLocator;
    
    /**
     * @param $serviceLocator \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function setServiceLocator(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator = $serviceLocator;
    }
    
    /**
     * @return \Zend\ServiceManager\ServiceLocatorInterface
     */
    public function getServiceLocator() {
        return $this->serviceLocator;
    }
    
}
