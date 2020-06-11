<?php 

namespace Colis\Factory;


use Colis\Controller\WriteController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class WriteControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$realServiceLocator = $serviceLocator->getServiceLocator();
		$colisService = $realServiceLocator->get('Colis\Service\ColisServiceInterface');
	    $colisInsertForm = $realServiceLocator->get('FormElementManager')->get('Colis\Form\ColisForm');
	    
	    return new WriteController($colisService, $colisInsertForm);
	    
	}
    
    
    
    
}








