<?php

namespace Base\Service\Factory;

use Zend\ServiceManager\FactoryInterface;

use Base\Constants as C;
use Base\Service\DisplayLink as Service;

class DisplayLink implements FactoryInterface {
    
    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return \Base\Service\DisplayLink
     */
    public function createService(\Zend\ServiceManager\ServiceLocatorInterface $serviceLocator) {
        
        $service = new Service();
        $service->setTable($serviceLocator->get(C::SM_TBL_INSERATBILDSCHIRMLINKER));
        
        return $service;
    }

}

