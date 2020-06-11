<?php
namespace Todolist\Factory;

 use Todolist\Controller\ListController;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 /**
  * Factory build the list controller injecting the task service
  */
 class ListControllerFactory implements FactoryInterface
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
         $taskService        = $realServiceLocator->get('Todolist\Service\TaskServiceInterface');

         return new ListController($taskService);
     }
 }