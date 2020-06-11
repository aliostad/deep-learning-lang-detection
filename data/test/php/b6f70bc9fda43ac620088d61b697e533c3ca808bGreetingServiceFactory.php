<?php
namespace Helloworld\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GreetingServiceFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$greetingService = new GreetingService();

        $hourProvider = new GreetingService\HourProviderDateFunction();
        $greetingService->setHourProvider($hourProvider);

		$greetingService->setEventManager(
			$serviceLocator->get('eventManager')
		);

		$greetingService->getEventManager()
			->attach(
				'getGreeting',
				function($e) use($serviceLocator) {
					$serviceLocator
						->get('loggingService')
						->onGetGreeting($e);
				}
		);

		return $greetingService;
	}

    /* Alternative implementation using the shared event manager
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator
            ->get('sharedEventManager')
            ->attach(
                'GreetingService',
                'getGreeting',
                function($e) use($serviceLocator) {
                    $serviceLocator
                        ->get('loggingService')
                        ->onGetGreeting($e);
                }
        );

        $greetingService = new GreetingService();
        return $greetingService;
    }*/

}