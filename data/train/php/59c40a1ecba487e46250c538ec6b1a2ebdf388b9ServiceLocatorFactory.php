<?php

namespace Cityware\Services;

use Zend\ServiceManager\ServiceManager;

class ServiceLocatorFactory
{
    /**
     * @var ServiceManager
     */
    private static $serviceManager = null;

    /**
     * @throw ServiceLocatorFactory\NullServiceLocatorException
     * @return Zend\ServiceManager\ServiceManager
     */
    public static function getInstance()
    {
        if (null === self::$serviceManager) {
            throw new NullServiceLocatorException('ServiceLocator is not set');
        }
        return self::$serviceManager;
    }

    /**
     * @param ServiceManager
     */
    public static function setInstance(ServiceManager $sm)
    {
        self::$serviceManager = $sm;
    }

}
