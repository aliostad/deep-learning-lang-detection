<?php
namespace Couchbase\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\Config\Config;

class CouchbaseFactory implements FactoryInterface
{
	/**
	 * Create service
	 *
	 * @param ServiceLocatorInterface $serviceLocator
	 * @return Couchbase\Service\Couchbase
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
	    $config = $serviceLocator->get('Config');
		$service = new Couchbase(new Config($config['couchbase']));
		return $service;
	}
}
