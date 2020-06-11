<?php

namespace Etah\Mvc\Factory\ServiceLocator;

use Etah\Mvc\Factory\ServiceLocator\NullServiceLocatorException;
use Zend\ServiceManager\ServiceManager;

class ServiceLocatorFactory
{
    
    private static $serviceManager = null;

    public static function getInstance()
    {
        if(null === self::$serviceManager) {
            throw new NullServiceLocatorException('ServiceLocator is not set');
        }
        return self::$serviceManager;
    }

   
    public static function setInstance(ServiceManager $serviceManager)
    {
        self::$serviceManager = $serviceManager;
    }
    
    
}