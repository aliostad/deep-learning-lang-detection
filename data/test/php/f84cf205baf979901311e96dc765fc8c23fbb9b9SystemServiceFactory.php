<?php

namespace Techfever\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

/**
 * Mobile Detect Module container abstract service factory.
 */
class SystemServiceFactory implements FactoryInterface {
	/**
	 * Create Template Module service
	 *
	 * @param ServiceLocatorInterface $serviceLocator        	
	 * @return Template
	 */
	public function createService(ServiceLocatorInterface $serviceLocator) {
		$options ['servicelocator'] = $serviceLocator;
		return new System ( $options );
	}
}