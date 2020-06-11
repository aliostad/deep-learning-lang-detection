<?php

namespace NetglueCreateSend\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use NetglueCreateSend\Service\SubscriptionService;


class SubscriptionServiceFactory implements FactoryInterface
{

    /**
     * Return SubscriptionService
     * @param ServiceLocatorInterface $serviceLocator
     * @return SubscriptionService
     * @throws \RuntimeException
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('Config');

        $client = $serviceLocator->get('NetglueCreateSendApi\Client\CreateSendClient');

        $service = new SubscriptionService($client);

        return $service;
    }

}
