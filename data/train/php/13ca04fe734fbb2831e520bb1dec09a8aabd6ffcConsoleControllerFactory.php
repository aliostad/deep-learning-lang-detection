<?php

namespace Ebay\Factory\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Ebay\Controller\ConsoleController;

class ConsoleControllerFactory implements FactoryInterface
{
    /**
     * @param ServiceLocatorInterface $serviceLocator
     *
     * @return ConsoleController
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $sm = $serviceLocator->getServiceLocator();

        $categoryService   = $sm->get(\Ebay\Service\CategoryService::class);
        $dataSourceService = $sm->get(\Utility\Service\DataSourceService::class);

        return new ConsoleController($categoryService, $dataSourceService);
    }
}
