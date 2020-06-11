<?php
 // Filename: /module/Places/src/Places/Factory/PlacesControllerFactory.php
 namespace Places\Factory;

 use Places\Controller\PlacesController;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 class PlacesControllerFactory implements FactoryInterface
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
         $placesService        = $realServiceLocator->get('Places\Service\PlacesServiceInterface');

         return new PlacesController($placesService);
     }
 }