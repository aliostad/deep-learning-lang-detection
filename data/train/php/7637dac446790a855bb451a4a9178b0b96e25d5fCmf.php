<?php

namespace Buser\Service;

use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\ServiceManager;

class Cmf implements ServiceManagerAwareInterface{
    
    /**
     * @var ServiceManager
     */
    protected $serviceManager;
    
   
    
 
    /**
     * Informacion de usuario desde Sesion
     * 
     * @return \Buser\Service\Cmf\User
     */
    public function getUser(){
        return new \Buser\Service\Cmf\User($this->getServiceManager());
    } 
 
    /**
     * Obtiene Service Manager
     * 
     * @return type
     */
    public function getServiceManager(){
        return $this->serviceManager;
    }

    /**
     * Inyecta Service Manager
     * 
     * @param \Zend\ServiceManager\ServiceManager $serviceManager
     * @return \Buser\Service\Cmf
     */
    public function setServiceManager(ServiceManager $serviceManager){
        $this->serviceManager = $serviceManager;
        return $this;
    }   
}
