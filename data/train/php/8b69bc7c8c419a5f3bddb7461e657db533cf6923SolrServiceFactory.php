<?php
namespace Vivo\Service;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;

/**
 * SolrServiceFactory
 * Instantiates the SolrService
 */
class SolrServiceFactory implements FactoryInterface
{
    /**
     * Create service
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        //TODO - configure Solr service using config
        $solrService    = new \ApacheSolr\Service('localhost', 8983, '/solr/');
        return $solrService;
    }
}