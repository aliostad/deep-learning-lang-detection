<?php

namespace BiBoBlog\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class BiBoBlogServiceFactory implements FactoryInterface
{

    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new \BiBoBlog\Service\BiBoBlogService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setOptions($serviceLocator->get('BiBoBlogOptions'));
        $service->setBiBoUserService($serviceLocator->get('BiBoUserService')) ;
//        $service->setFileService($serviceLocator->get('OdiFileService')) ;
//        $service->setDiaryEntryService($serviceLocator->get('OdiDiaryEntryService')) ;

        return $service;
    }
}