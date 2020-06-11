<?php
namespace Application\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ContactControllerFactory 
implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$contactService = $serviceLocator->getServiceLocator()->get('Application\Service\Contact');
		$personService = $serviceLocator->getServiceLocator()->get('Application\Service\Person');
		return new ContactController($contactService, $personService);
	}
}