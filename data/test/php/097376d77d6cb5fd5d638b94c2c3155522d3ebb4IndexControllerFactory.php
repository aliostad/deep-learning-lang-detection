<?php
/**
 * IndexControllerFactory
 * 
 * @author  Sarjono Mukti Aji <me@simukti.net>
 */
namespace SmxGoogleAuth\Controller;

use Zend\ServiceManager\FactoryInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class IndexControllerFactory implements FactoryInterface
{
    public function createService(ServiceLocatorInterface $serviceLocator) 
    {
        $serviceManager = $serviceLocator->getServiceLocator();
        $controller     = new IndexController();
        $controller->setSessionService(
                        $serviceManager->get('smx.googleauth.service.session')
                    )
                   ->setAuthService(
                        $serviceManager->get('smx.googleauth.service.auth')
                    );
        
        return $controller;
    }
}
