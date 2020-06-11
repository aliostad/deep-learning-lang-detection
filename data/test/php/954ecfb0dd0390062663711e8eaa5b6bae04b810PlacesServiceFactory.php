<?php
 // Filename: /module/Places/src/Places/Factory/PlacesServiceFactory.php
 namespace Places\Factory;

 use Places\Service\PlacesService;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 class PlacesServiceFactory implements FactoryInterface
 {
     /**
      * Create service
      *
      * @param ServiceLocatorInterface $serviceLocator
      * @return mixed
      */
     public function createService(ServiceLocatorInterface $serviceLocator)
     {
         return new PlacesService(
             $serviceLocator->get('Places\Mapper\PlacesMapperInterface')
         );
     }
 }