<?php
namespace Forum\Factory;

use Forum\Service\PageService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class PageServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new PageService(
            $serviceLocator->get('Forum\Mapper\PageMapperInterface')
        );
    }
}