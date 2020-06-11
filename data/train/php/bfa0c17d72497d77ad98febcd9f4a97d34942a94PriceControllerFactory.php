<?php

namespace Application\Factory\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Controller\PriceController;

class PriceControllerFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return PriceController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm = $serviceLocator->getServiceLocator();

        $subscriptionService = $sm->get(\Utility\Service\SubscriptionService::class);
        $dataSourceService   = $sm->get(\Utility\Service\DataSourceService::class);

        return new PriceController(
            $subscriptionService,
            $dataSourceService
        );
    }
}
