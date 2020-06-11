<?php
namespace Console\Service;

use Console\Application;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ApplicationFactory implements FactoryInterface
{
    /**
     * Create the Application service
     *
     * Creates a Console\Application service, passing it the configuration
     * service and the service manager instance.
     *
     * @param  ServiceLocatorInterface $serviceLocator
     * @return Application
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new Application($serviceLocator->get('Config'), $serviceLocator);
    }
}
