<?php

namespace BaseXMS\Mvc;

use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\ServiceManager\ServiceLocatorAwareInterface;

class BaseXMSService implements ServiceLocatorAwareInterface
{
	protected $serviceManager;
	
	/* (non-PHPdoc)
	 * @see Zend\ServiceManager.ServiceLocatorAwareInterface::setServiceLocator()
	*/
	public function setServiceLocator( ServiceLocatorInterface $serviceLocator )
	{
		$this->serviceManager = $serviceLocator;
	}
	
	/* (non-PHPdoc)
	 * @see Zend\ServiceManager.ServiceLocatorAwareInterface::getServiceLocator()
	*/
	public function getServiceLocator()
	{
		return $this->serviceManager;
	}

}

?>