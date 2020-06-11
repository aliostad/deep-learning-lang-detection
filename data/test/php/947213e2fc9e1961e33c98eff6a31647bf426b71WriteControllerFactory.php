<?php
namespace Login\Factory;

use Login\Controller\WriteController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;


class WriteControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
	   $realServiceLocator = $serviceLocator->getServiceLocator();
	   $userService = $realServiceLocator->get('Login\Service\UserServiceInterface');
	   $userInsertForm = $realServiceLocator->get('FormElementManager')->get('Login\Form\UserForm');
	   
	   return new WriteController($userService, $userInsertForm);
    }
}