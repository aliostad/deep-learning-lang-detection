<?php

namespace AgcodModule;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * AgcodModule/AgcodServiceFactory
 */
class AgcodServiceFactory implements FactoryInterface
{

    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return \AgcodServices\Service
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $logger = null;
        if ($serviceLocator->has('logger')) {
            $logger = $serviceLocator->get('logger');
        }

        $agcodClient = $serviceLocator->get('Agcod\AgcodClient');

        $service = new \AgcodServices\Service($agcodClient, $logger);

        return $service;
    }
}