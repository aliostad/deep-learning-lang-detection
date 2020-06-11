<?php

namespace Helloworld\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GreetingServiceFactory implements FactoryInterface {

    public function createService(ServiceLocatorInterface $serviceLocator) {
        $greetingService = new GreetingService();

        $greetingService->setEventManager(
                $serviceLocator->get('eventManager')
        );

        $greetingService->getEventManager()
                ->attach(
                        'getGreeting', function($e) use($serviceLocator) {
                            $serviceLocator
                            ->get('loggingService')
                            ->onGetGreeting($e);
                        }
        );

        return $greetingService;
    }

}