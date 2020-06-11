<?php

namespace Common\Factory;

use Common\Service\CommonService;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class CommonServiceFactory implements FactoryInterface {
	/**
	 * Create service
	 *
	 * @param ServiceLocatorInterface $serviceLocator        	
	 * @return mixed
	 */
	public function createService(ServiceLocatorInterface $serviceLocator) {
		return new CommonService ( $serviceLocator->get ( 'Common\Mapper\CommonSqlMapperInterface' ) );
	}
}