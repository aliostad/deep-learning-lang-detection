<?php

namespace Helloworld\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IndexControllerFactory implements FactoryInterface 
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /*$ctr = new IndexController();
        $ctr->setGreetingService(
                    $serviceLocator->getServiceLocator()
                                   ->get('greetingService')
                );*/
        
        $ctr = new IndexController();
        $greetingSrv = $serviceLocator->getServiceLocator()
                                      ->get('Helloworld\Service\GreetingService');
        $ctr->setGreetingService($greetingSrv);
        
        return $ctr;
    }
}
