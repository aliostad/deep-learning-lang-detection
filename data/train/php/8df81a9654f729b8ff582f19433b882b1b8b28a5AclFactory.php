<?php

namespace User\Service;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use User\Service\Acl;

/*
 * @author nmt
 *
 */
class AclFactory implements FactoryInterface {
	
	
	/**
	 * 
	 * {@inheritDoc}
	 * @see \Zend\ServiceManager\FactoryInterface::createService()
	 */
	public function createService(ServiceLocatorInterface $serviceLocator) {
	
		$service = new Acl();
		
		$tbl =  $serviceLocator->get ('User\Model\AclResourceTable' );
		$service->setAclResourceTable($tbl);

		$tbl =  $serviceLocator->get ('User\Model\AclRoleTable' );
		$service->setAclRoleTable($tbl);
		
		
		return $service;
	}
}