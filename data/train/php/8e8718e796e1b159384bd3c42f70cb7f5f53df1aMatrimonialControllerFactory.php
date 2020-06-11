<?php

 namespace Application\Controller\Factory;

use Application\Controller\MatrimonialController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

 class MatrimonialControllerFactory implements FactoryInterface
 {
     /**
      * Create service
      *
      * @param ServiceLocatorInterface $serviceLocator
      *
      * @return mixed
      */
     public function createService(ServiceLocatorInterface $serviceLocator)
     {
         $realServiceLocator = $serviceLocator->getServiceLocator();
         $matrimonialService        = $realServiceLocator->get('Application\Service\MatrimonialServiceInterface');
         $profileService        = $realServiceLocator->get('Application\Service\ProfileServiceInterface');
         $userService = $realServiceLocator->get('Application\Service\UserServiceInterface');
         $commonService = $realServiceLocator->get('Common\Service\CommonServiceInterface');

         return new MatrimonialController($matrimonialService, $profileService, $commonService, $userService);
     }
 }