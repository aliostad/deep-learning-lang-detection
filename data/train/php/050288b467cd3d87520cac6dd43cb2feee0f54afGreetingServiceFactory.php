<?php

namespace Helloworld\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GreetingServiceFactory implements FactoryInterface{
    
    public function createService(ServiceLocatorInterface $serviceLocator) {
        
        $greetingService = new GreetingService();
        
        $greetingService->setEventManager(
            $serviceLocator->get('eventManager')
        );
        
        $loggingService = new LoggingService();
        
        $greetingService->getEventManager()
                ->attach(
                            'getGreeting',
                            array($loggingService, 'onGetGreeting')
                        );
        
        return $greetingService;
    }
}

