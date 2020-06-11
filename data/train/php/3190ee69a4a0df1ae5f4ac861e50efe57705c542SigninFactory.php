<?php
namespace Application\Factory\Controller;

use Application\Controller\SigninController;
use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class SigninFactory implements FactoryInterface
{
    /**
     * Create service
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return mixed
     */
    public function createService(ServiceLocatorInterface $serviceLocator)
    {
        $serviceLocator = $serviceLocator->getServiceLocator();
        return new SigninController(
            $serviceLocator->get('Stormpath\Client'),
            $serviceLocator->get('Stormpath\Resource\Application'),
            $serviceLocator->get('Zend\Authentication\AuthenticationService')
         );
    }
}