<?php

namespace Application\PluginManager;

use Zend\ServiceManager\InitializerInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceLocatorInitializer implements InitializerInterface
{
    public function initialize($instance, ServiceLocatorInterface $serviceLocator)
    {
        if ($serviceLocator instanceof ServiceLocatorAwareInterface) {
            $serviceLocator = $serviceLocator->getServiceLocator();
        }

        if ($instance instanceof ServiceLocatorAwareInterface) {
            $instance->setServiceLocator($serviceLocator);
        }

        return $instance;
    }
}
