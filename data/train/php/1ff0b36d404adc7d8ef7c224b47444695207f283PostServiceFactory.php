<?php
 // Filename: /module/Category/src/Category/Factory/PostServiceFactory.php
 namespace Category\Factory;

 use Category\Service\PostService;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 class PostServiceFactory implements FactoryInterface
 {
     /**
      * Create service
      *
      * @param ServiceLocatorInterface $serviceLocator
      * @return mixed
      */
     public function createService(ServiceLocatorInterface $serviceLocator)
     {
         return new PostService(
             $serviceLocator->get('Category\Mapper\PostMapperInterface')
         );
     }
 }