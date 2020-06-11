<?php
namespace Colis\Factory;


use Colis\Controller\DeleteController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocationInterface;
use Zend\Di\ServiceLocator;
use Zend\ServiceManager\ServiceLocatorInterface;

class DeleteControllerFactory implements FactoryInterface
{
	public function createService(ServiceLocatorInterface $serviceLocator)
	{
		$realServiceLocator = $serviceLocator->getServiceLocator();
		$colisService = $realServiceLocator->get('Colis\Service\ColisServiceInterface');
		
		return new DeleteController($colisService);
	}
    
    
    
}