<?php
/**
 * Class RouterServiceFactory
 */
namespace Base\Router\Factory;

use Base\Router\RouterService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RouterServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $router = $serviceLocator->get('Router');
        $request = $serviceLocator->get('Request');

        return new RouterService($router, $request);
    }
} 