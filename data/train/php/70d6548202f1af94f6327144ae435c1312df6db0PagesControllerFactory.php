<?php
 namespace Reservations\Factory;

 use Reservations\Controller\PagesController;
 use Reservations\Service\CustomerService;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 class PagesControllerFactory implements FactoryInterface
 {
     
     public function createService(ServiceLocatorInterface $serviceLocator)
     {
         $realServiceLocator = $serviceLocator->getServiceLocator();
         $customerService = $realServiceLocator->get('Reservations\Service\CustomerService');
         
         return new PagesController($customerService);
     }
 }

