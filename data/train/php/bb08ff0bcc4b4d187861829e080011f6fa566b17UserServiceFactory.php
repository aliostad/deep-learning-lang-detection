<?php
 namespace User\Factory;

 use User\Service\UserService;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;
 
/**
  * Factory build the delete controller injecting the task service
  */
 class UserServiceFactory implements FactoryInterface
 {
     /**
      * Create service
      *
      * @param ServiceLocatorInterface $serviceLocator
      * @return mixed
      */
     public function createService(ServiceLocatorInterface $serviceLocator)
     {
         return new UserService(
             $serviceLocator->get('User\Mapper\UserMapperInterface')
         );
     }
 }