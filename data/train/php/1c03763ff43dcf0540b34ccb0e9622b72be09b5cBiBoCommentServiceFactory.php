<?php

namespace BiBoComment\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class BiBoCommentServiceFactory implements FactoryInterface
{

    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new \BiBoComment\Service\BiBoCommentService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setOptions($serviceLocator->get('BiBoCommentOptions'));
        $service->setBiBoBlogService($serviceLocator->get('BiBoBlogService')) ;
//        $service->setFileService($serviceLocator->get('OdiFileService')) ;
//        $service->setDiaryEntryService($serviceLocator->get('OdiDiaryEntryService')) ;

        return $service;
    }
}