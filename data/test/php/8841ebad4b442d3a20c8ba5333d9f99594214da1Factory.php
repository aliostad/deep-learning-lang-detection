<?php

namespace Geoname\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class Factory implements FactoryInterface {
    
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $ServiceLocator)
    {
        
        if(class_exists('\Geoname\Service\Service')){
            $instance = new \Geoname\Service\Service($ServiceLocator);
        
            return $instance;    
        }
        
        throw new \Exception('Could not create GeonameManager service');
    }
    
}