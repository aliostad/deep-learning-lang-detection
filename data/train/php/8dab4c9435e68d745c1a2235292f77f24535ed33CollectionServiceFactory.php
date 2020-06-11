<?php
namespace Collection\Service;
use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface;
use Article\Table\ArticleTable,
    Collection\Table\CollectionTable;
class CollectionServiceFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return CollectionService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /** @var ArticleTable $articleTable */
        $articleTable = $serviceLocator->get('Article\Table\Article');

        $service = new CollectionService($articleTable);
        return $service;
    }

} 