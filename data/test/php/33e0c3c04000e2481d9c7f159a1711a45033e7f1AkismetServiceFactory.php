<?php

namespace NetglueAkismet\Factory;

use Silver\Exception;

use NetglueAkismet\Service\AkismetService;
use NetglueAkismet\Options\AkismetServiceOptions;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AkismetServiceFactory implements FactoryInterface {
	
	/**
	 * Return Akismet Service
	 * @return AkismetService
	 */
	public function createService(ServiceLocatorInterface $serviceLocator) {
		$config = $serviceLocator->get('Config');
		$options = array();
		if(isset($config['netglue_akismet'])) {
			$options = $config['netglue_akismet'];
		}
		// Options
		$service = new AkismetService;
		$service->setOptions($options);
		
		return $service;
  }
	
}
