<?php

namespace JVUser\View\Helper;

use Zend\View\Helper\AbstractHelper;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class JVUserIdentity extends AbstractHelper implements ServiceLocatorAwareInterface
{
	protected $serviceLocator;
	
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }
    
    public function __invoke()
    {
        $helperPluginManager = $this->getServiceLocator();
        $serviceManager = $helperPluginManager->getServiceLocator();
        $usuarioService = $serviceManager->get('jvuser_service_auth');
        
        if ($usuarioService->hasIdentity())
        {
            return $usuarioService->UserAuthentication();
        }
        else 
        {
            return false;
        }
    }
}