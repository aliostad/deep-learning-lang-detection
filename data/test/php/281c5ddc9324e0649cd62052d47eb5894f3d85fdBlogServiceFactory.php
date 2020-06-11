<?php

namespace Blog\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Create blog service factory
 * 
 * @package    Blog
 */
class BlogServiceFactory implements FactoryInterface
{
    /**
     * Create Service Factory
     * 
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $table   = $serviceLocator->get('Blog\Table\Blog');
        $service = new BlogService($table);
        return $service;
    }
}
