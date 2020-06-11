<?php
namespace CloudFlare\Factory;

use CloudFlare\Controller\SettingsConsoleController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class SettingsConsoleControllerFactory implements FactoryInterface
{
    /**
     * @param  ServiceLocatorInterface $serviceLocator
     * @return SettingsConsoleController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator();
        $settingsService = $serviceLocator->get('CloudFlare\Service\SettingsService');

        return new SettingsConsoleController($settingsService);
    }
}