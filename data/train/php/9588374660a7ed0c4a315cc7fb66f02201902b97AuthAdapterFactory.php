<?php
namespace XOUser\Factory\Authentication\Adapter;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use XOUser\Authentication\Adapter\AuthAdapter;

class AuthAdapterFactory implements FactoryInterface 
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */	
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$adapter = new AuthAdapter();
		$adapter->setServiceManager($serviceLocator);
		return $adapter;
	}
}