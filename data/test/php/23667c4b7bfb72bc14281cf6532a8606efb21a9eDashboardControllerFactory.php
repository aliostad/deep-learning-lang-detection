<?php
 namespace User\Factory;

 use User\Controller\DashboardController;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 class DashboardControllerFactory implements FactoryInterface
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
         $userService        = $realServiceLocator->get('User\Service\UserServiceInterface');
         $commonService = $realServiceLocator->get('Common\Service\CommonServiceInterface');
         return new DashboardController($userService,$commonService);
     }
 }
