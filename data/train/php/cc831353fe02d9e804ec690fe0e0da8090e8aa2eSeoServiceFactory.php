<?php

namespace EnliteSeo\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use EnliteSeo\Service\SeoService;

class SeoServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface|ServiceManager $serviceLocator
     * @return SeoService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new SeoService($serviceLocator);
    }


}
