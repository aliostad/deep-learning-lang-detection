<?php
namespace Application\Factory;

use Application\Service\ElasticSearch as ElasticSearchService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Class ElasticSearchServiceFactory
 * @package Application\Factory
 */
class ElasticSearchServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return ElasticSearchService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new ElasticSearchService(
            $serviceLocator
        );
    }
}
