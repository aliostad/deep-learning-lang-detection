<?php

namespace Conferences\Service;

use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface;

use Conferences\Service\ConferenceService;

class ConferenceServiceFactory implements FactoryInterface {
    
    /**
     * @param \Zend\ServiceManager\ServiceLocatorInterface $serviceLocator
     * @return \Conferences\Service\ConferenceService
     */
	public function createService(ServiceLocatorInterface $serviceLocator) {
        
        // Dependencies are fetched from Service Manager
        $entityManager = $serviceLocator->get('doctrine.entitymanager.orm_default');
        
        $authorize = $serviceLocator->get('BjyAuthorize\Service\Authorize');
        
        return new ConferenceService($entityManager, $authorize);
		
	}
  
}