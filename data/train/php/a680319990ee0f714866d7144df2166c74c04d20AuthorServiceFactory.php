<?php

namespace Application\Service;

use Zend\ServiceManager\FactoryInterface,
    Zend\ServiceManager\ServiceLocatorInterface;

use Application\Service\BookService;

class AuthorServiceFactory implements FactoryInterface {

	public function createService(ServiceLocatorInterface $serviceLocator) {
        
        // Dependencies are fetched from Service Manager
        $entityManager = $serviceLocator->get('doctrine.entitymanager.orm_default');

        return new AuthorService($entityManager);
		
	}
        

}