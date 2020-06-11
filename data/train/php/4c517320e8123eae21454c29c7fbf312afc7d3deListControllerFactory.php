<?php
namespace Application\Factory;

 use Application\Controller\ListController;
 use Zend\ServiceManager\FactoryInterface;
 use Zend\ServiceManager\ServiceLocatorInterface;

 class ListControllerFactory implements FactoryInterface
 {

     public function createService(ServiceLocatorInterface $serviceLocator)
     {
         $realServiceLocator = $serviceLocator->getServiceLocator();
         $postService        = $realServiceLocator->get('Application\Service\PostServiceInterface');

         return new ListController($postService);
     }
 }
