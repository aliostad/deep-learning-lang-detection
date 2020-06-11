<?php
namespace Admin\Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class AccessStatus implements ServiceLocatorAwareInterface
{
    protected $_serviceLocator;

    public function __construct()
    {}
    
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->_serviceLocator = $serviceLocator;
    }    
    
    public function getServiceLocator()
    {
        return $this->_serviceLocator;
    }
    
    public function getTerci() {
        $auth = $this->getServiceLocator()->get('doctrine.authenticationservice.orm_admins');;
        $admin_user = $auth->getIdentity();
        
        return $admin_user->getUsername();
    }

}
