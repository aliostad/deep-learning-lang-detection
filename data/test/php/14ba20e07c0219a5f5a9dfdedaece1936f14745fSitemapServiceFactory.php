<?php

namespace EnliteSitemap\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use EnliteSitemap\Service\SitemapService;

class SitemapServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface|ServiceManager $serviceLocator
     * @return SitemapService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new SitemapService($serviceLocator);
    }


}
