<?php
namespace HtSettingsModule\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use HtSettingsModule\Service\SettingsService;

class SettingsServiceFactory implements FactoryInterface
{
    /**
     * Gets settings service
     *
     * @param  ServiceLocatorInterface $serviceLocator
     * @return SettingsService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $options = $serviceLocator->get('HtSettingsModule\Options\ModuleOptions');
        $settingsService = new SettingsService(
            $options,
            $serviceLocator->get('HtSettingsModule_SettingsMapper'),
            $serviceLocator->get('HtSettingsModule\Service\NamespaceHydratorProvider')
        );
        if ($options->getCacheOptions()->isEnabled()) {
            $settingsService->setCacheManager($serviceLocator->get('HtSettingsModule\Service\CacheManager'));
        }

        return $settingsService;
    }
}
