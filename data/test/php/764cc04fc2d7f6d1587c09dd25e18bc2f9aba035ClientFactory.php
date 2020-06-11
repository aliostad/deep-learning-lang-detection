<?php

namespace GoogleGlass\Api;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\Config;

class ClientFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $api = new Client();
    	
        $sm = $serviceLocator->createScopedServiceManager(ServiceManager::SCOPE_PARENT);
    	
    	$configObj = new Config($api->getServiceConfig());
    	$configObj->configureServiceManager($sm);
    	
    	$api->setServiceLocator($sm);

    	return $api;
    }
}
