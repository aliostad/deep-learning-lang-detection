<?php

namespace ZfcUserMetadata\Service;

use Zend\ServiceManager\ServiceLocatorInterface;
use ZfcUser\Service\AbstractServiceFactory;

class MetadataServiceFactory extends AbstractServiceFactory
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @throws \InvalidArgumentException
     * @return LoginService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var \ZfcUserMetadata\ModuleOptions $options */
        $options = $serviceLocator->get('ZfcUserMetadata\ModuleOptions');
        $service = new MetadataService();

        foreach ($options->getPlugins() as $plugin) {
            $service->registerPlugin($this->get($serviceLocator, $plugin));
        }

        return $service;
    }
}