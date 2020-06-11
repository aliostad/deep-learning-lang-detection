<?php

namespace NewsCorpAU\Foundation;

/**
 * Class ServiceLocator
 * @package NewsCorpAU\Foundation
 */
class ServiceLocator extends ServiceLocatorAbstract
{
    /**
     * @var ServiceLocatorInterface
     */
    protected static $serviceLocator;

    /**
     * Set instance of the Service Locator
     *
     * @param ServiceLocatorInterface $serviceLocator Service Locator
     */
    public static function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        self::$serviceLocator = $serviceLocator;
    }

    /**
     * Get instance of the Service Locator
     *
     * @return ServiceLocator
     */
    public static function getServiceLocator()
    {
        if (!( self::$serviceLocator instanceof ServiceLocatorInterface )) {
            throw new \RuntimeException('Service Locator instance is not set');
        }

        return self::$serviceLocator;
    }
}