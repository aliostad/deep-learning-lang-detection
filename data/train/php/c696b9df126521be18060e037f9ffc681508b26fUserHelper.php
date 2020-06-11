<?php 

namespace User\Helper;

use MyZend\Service\Service as Service;

use Zend\ServiceManager\ServiceLocatorAwareInterface;  
use Zend\ServiceManager\ServiceLocatorInterface;

class UserHelper extends Service implements ServiceLocatorAwareInterface
{
    protected $services;
	
	public function __construct($serviceLocator) {
        $this->setServiceLocator($serviceLocator);
	}
	
 	public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->services = $serviceLocator;
    }

    public function getServiceLocator()
    {
        return $this->services;
    }

    public function getCurrentUser($user){
    	$service = $this->getServiceLocator()->get('userService');
    	$user = $service->findOneBy(array('_id' => $user->getId()));
    	return $user;
    }	

    public function saveUser($user){
    	$this->getServiceLocator()->get('userService')->save($user);
    }

}