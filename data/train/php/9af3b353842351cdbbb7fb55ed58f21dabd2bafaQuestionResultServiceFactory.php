<?php

namespace LrnlListquests\Service;

use LrnlListquests\Service\QuestionresultService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class QuestionresultServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $services)
    {
        $objectManager = $services->get('doctrine.entitymanager.orm_default');
        $options = $services->get('lrnllistquests_module_options');
        $service   = new QuestionresultService($objectManager,$options);
        
        return $service;
    }
}