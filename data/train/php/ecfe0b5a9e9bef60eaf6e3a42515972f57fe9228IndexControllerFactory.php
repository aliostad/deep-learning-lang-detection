<?php

namespace Application\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

use Application\Controller\IndexController;

class IndexControllerFactory 
implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator( );

        $name = 'Domain\Service\ArticleService';
        if ($serviceLocator->has($name))
        {
            $articleService = $serviceLocator->get($name);    
        } else {
            throw new \Exception ("Failed to locate " . $name . ".");
        }

        $name = 'Domain\Service\ArticleCategoryService';
        if ($serviceLocator->has($name))
        {
            $articleCategoryService = $serviceLocator->get($name);    
        } else {
            throw new \Exception ("Failed to locate " . $name . ".");
        }
        
        return new IndexController($articleService, $articleCategoryService);
    }
}