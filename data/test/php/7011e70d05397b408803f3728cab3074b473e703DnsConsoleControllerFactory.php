<?php
namespace CloudFlare\Factory;

use CloudFlare\Controller\DnsConsoleController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class DnsConsoleControllerFactory implements FactoryInterface
{
    /**
     * @param  ServiceLocatorInterface $serviceLocator
     * @return DnsConsoleController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator();
        $dnsService = $serviceLocator->get('CloudFlare\Service\DnsService');

        return new DnsConsoleController($dnsService);
    }
}