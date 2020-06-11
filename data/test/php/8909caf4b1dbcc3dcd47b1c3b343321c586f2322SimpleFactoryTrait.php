<?php

namespace GoogleGlass\Entity;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;

trait SimpleFactoryTrait 
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $retval = new static();
        
        if($retval instanceof ServiceLocatorAwareInterface)
        {
            if(!$retval->getServiceLocator() instanceof ServiceLocatorInterface) {
                $retval->setServiceLocator($serviceLocator);
            }
        }
        
        return $retval;
    }
}