<?php
/**
 * SimpleSoft (http://simplesoft.pl)
 *
 * @link      https://github.com/mrova/simple-image
 * @copyright Copyright (c) 2014 SimpleSoft (http://simplesoft.pl)
 * @license   New BSD License
 */

namespace SimpleImage\Factory;

use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\FactoryInterface;
use SimpleImage\Service\UserRegistrationService;
use SimpleImage\Service\ImageService;

class ImageServiceFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$service = new ImageService();
		$service->setServiceLocator($serviceLocator);

		return $service;
	}
}