<?php

namespace Columnis\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Columnis\Service\PageService;

class PageServiceFactory implements FactoryInterface
{

    /**
     * {@inheritDoc}
     *
     * @return PageService
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $templateService = $serviceLocator->get('Columnis\Service\TemplateService');
        /* @var \Columnis\Service\TemplateService $templateService */
        
        $apiService = $serviceLocator->get('Columnis\Service\ApiService');
        /* @var \Columnis\Service\ApiService $apiService */

        return new PageService($templateService, $apiService);
    }
}
