<?php
namespace User\Factory;

use User\Plugin\ActiveUser;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ActiveUserPluginFactory implements FactoryInterface{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {

        $plugin = new ActiveUser();
        $plugin->setServiceManager($serviceLocator->getServiceLocator());
        return $plugin;
    }

}

