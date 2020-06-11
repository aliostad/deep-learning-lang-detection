<?php
namespace Forum\Factory;

use Forum\Service\RFollowService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class RFollowServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new RFollowService(
            $serviceLocator->get('Forum\Mapper\RFollowMapperInterface')
        );
    }
}