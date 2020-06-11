<?php
namespace Forum\Factory;

use Forum\Service\FollowService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class FollowServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new FollowService(
            $serviceLocator->get('Forum\Mapper\FollowMapperInterface')
        );
    }
}