<?php

namespace Helloworld\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class GreetingServiceFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
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

		$greetingService = new GreetingService();
		$greetingService->setLoggingService(
			$serviceLocator->get('loggingService')
		);

		return $greetingService;
	}
}