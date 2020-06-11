<?php

namespace Application\Factory;

use Application\Adapter\ExchangeAdapter;
use Application\Service\TradeService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class TradeServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $config = $serviceLocator->get('config');
        $exchange = new ExchangeAdapter($serviceLocator->get($config['application']['exchange']['adapter']));
        return new TradeService($exchange);
    }
}