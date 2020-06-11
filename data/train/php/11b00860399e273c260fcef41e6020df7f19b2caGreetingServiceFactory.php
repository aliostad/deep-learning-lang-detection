<?php
namespace Course\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Di\Config;

class GreetingServiceFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$di = new \Zend\Di\Di(); 
		$di->configure(new \Zend\Di\Config(
				array(
					'definition' => array(
						'class' => array(
								'Course\Service\GreetingService' => array(
										'setLoggingService' => array(
												'required' => true,
												)
										)
								)	
					),
					'instance' => array(
						'preferences' => array(
								'Course\Service\LoggingServiceInterface' 
									=> 'Course\Service\LoggingService'
							)
					)
		)));
		
		$greetingService = $di->get('Course\Service\GreetingService');
		if ( $greetingService ){
			echo "\n GREETING SERVICE is GOT";
		}
		/*echo("\n GreetingServiceFactoryfactory createService:");
		$greetingService->setLoggingService(
			$serviceLocator->get('loggingService')
		);*/
		return $greetingService;
	}
}
