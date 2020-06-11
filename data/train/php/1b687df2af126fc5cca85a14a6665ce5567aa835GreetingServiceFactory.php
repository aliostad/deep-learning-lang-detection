<?php

namespace Helloworld\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GreetingServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        /*$greetingService = new GreetingService();
        $greetingService->setEventManager(
                    $serviceLocator->get('eventManager')
                );
        
        $greetingService->getEventManager()
                        ->attach(
                                    'getGreeting',
                                    function($e) use ($serviceLocator) {
                                        $serviceLocator->get('loggingService')
                                                       ->onGetGreeting($e);
                                    }
                                );*/
        
        
        /*$serviceLocator->get('sharedEventManager')
                       ->attach(
                               'GreetingService',
                               'getGreeting',
                               function($e) use($serviceLocator) {
                                    $serviceLocator->get('loggingService')
                                                   ->onGetGreeting($e);
                               }
                         );
        $greetingService = new GreetingService();
        return $greetingService;*/
        
        
        $di = new \Zend\Di\Di();
        $di->configure(new \Zend\Di\Config(array(
            'definition' => array(
                'class' => array(
                    'Helloworld\Service\GreetingService' => array(
                        'setLoggingService' => array(
                            'required' => true
                        )
                    )
                )
            ),
            'instance' => array(
                'preferences' => array(
                    'Helloworld\Service\LoggingServiceInterface'
                                => 'Helloworld\Service\LoggingService'
                )
            )
        )));
        
        $greetingService = $di->get('Helloworld\Service\GreetingService');
        return $greetingService;
    }
}
