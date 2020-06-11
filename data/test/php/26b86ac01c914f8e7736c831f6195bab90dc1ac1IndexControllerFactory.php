<?php
namespace Application\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Controller\IndexController as Controller;
 
class IndexControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator) 
    {
        $sm = $serviceLocator->getServiceLocator();

        $myService = $sm->get('Smtest\Service\MyService');
        $controller = new Controller($myService);
        
        return $controller;
    }
}