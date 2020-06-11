<?php

namespace BsbPhingService\Service\Factory;

use BsbPhingService\Options\PhingOptions;
use BsbPhingService\Options\ServiceOptions;
use BsbPhingService\Service\PhingService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class PhingServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return PhingService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var ServiceOptions $options */
        $options = $serviceLocator->get('BsbPhingService.serviceOptions');
        /** @var PhingOptions $phingOptions */
        $phingOptions = $serviceLocator->get('BsbPhingService.phingOptions');

        return new PhingService($options, $phingOptions);
    }
}
