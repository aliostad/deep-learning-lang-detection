<?php
namespace HtProfileImage\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use HtProfileImage\Service\ProfileImageService;

class ProfileImageServiceFactory implements FactoryInterface
{
    /**
     * gets ProfileImageService Service
     *
     * @param  ServiceLocatorInterface $serviceLocator
     * @return ProfileImageService
     */
     public function createService(ServiceLocatorInterface $sm)
     {
        $service = new ProfileImageService();
        $service->setServiceLocator($sm);

        return $service;
     }
}
