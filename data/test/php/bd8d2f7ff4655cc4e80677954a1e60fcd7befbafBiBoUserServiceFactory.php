<?php

namespace BiBoUser\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class BiBoUserServiceFactory implements FactoryInterface
{

    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $service = new \BiBoUser\Service\BiBoUserService();
        $service->setEntityManager($serviceLocator->get('doctrine.entitymanager.orm_default'));
        $service->setOptions($serviceLocator->get('BiBoUserOptions'));
//        $service->setLoginService($serviceLocator->get('OdiLoginService')) ;
//        $service->setFileService($serviceLocator->get('OdiFileService')) ;
//        $service->setDiaryEntryService($serviceLocator->get('OdiDiaryEntryService')) ;

        return $service;
    }
}