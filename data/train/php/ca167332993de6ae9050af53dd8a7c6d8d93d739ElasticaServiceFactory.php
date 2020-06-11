<?php

namespace Application\Service\ElasticSearch\Factory;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Service\ElasticSearch\ElasticaService;

/**
 *
 * @author arstropica
 *        
 */
class ElasticaServiceFactory implements FactoryInterface {

	/**
	 * (non-PHPdoc)
	 *
	 * @see \Zend\ServiceManager\FactoryInterface::createService()
	 *
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$elastica_service = new ElasticaService($serviceLocator);
		$elastica_service->init();
		return $elastica_service;
	}
}

?>