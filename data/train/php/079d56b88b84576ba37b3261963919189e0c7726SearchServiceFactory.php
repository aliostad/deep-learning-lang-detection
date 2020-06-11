<?php
namespace SphinxSearch\Search;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Factory class for Search Service
 */
class SearchServiceFactory implements FactoryInterface
{
    /**
     * Creates the Search service
     *
     * @param  ServiceLocatorInterface $serviceLocator
     *
     * @return Search
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        return new Search();
    }
}
