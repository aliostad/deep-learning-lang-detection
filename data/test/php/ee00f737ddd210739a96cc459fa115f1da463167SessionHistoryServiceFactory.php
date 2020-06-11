<?php

namespace Application\Service\Factory;

use Zend\ServiceManager\FactoryInterface;
use Application\Provider\ServiceLocatorAwareTrait;
use Zend\ServiceManager\ServiceLocatorInterface;
use Application\Service\SessionHistoryService;

/**
 *
 * @author arstropica
 *        
 */
class SessionHistoryServiceFactory implements FactoryInterface {
	
	use ServiceLocatorAwareTrait;

	/**
	 * (non-PHPdoc)
	 *
	 * @see \Zend\ServiceManager\FactoryInterface::createService()
	 *
	 */
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$this->setServiceLocator($serviceLocator);
		
		return new SessionHistoryService($serviceLocator);	
	}
}

?>