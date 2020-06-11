<?php
namespace Vivo\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * StatusFactory
 */
class StatusFactory implements FactoryInterface
{
    /**
     * Create service
     * @param ServiceLocatorInterface $serviceLocator
     * @throws Exception\RuntimeException
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var $routeMatchService RouteMatchService */
        $routeMatchService  = $serviceLocator->get('Vivo\route_match_service');
        $request            = $serviceLocator->get('request');
        $status             = new Status($routeMatchService, $request);
        return $status;
    }
}
