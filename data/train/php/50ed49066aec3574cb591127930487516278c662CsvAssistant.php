<?php

namespace CdiCommons\Service;
use Zend\ServiceManager\ServiceManagerAwareInterface;
/**
* TITLE
*
* Description
*
* @author Cristian Incarnato <cristian.cdi@gmail.com>
*
* @package Paquete
*/


class CsvAssistant implements ServiceManagerAwareInterface{
    
    
    public function import($csv){
        
        
    }
    
     public function export(){
        
        
    }
    
    
     /**
     * Retrieve service manager instance
     *
     * @return ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }

    /**
     * Set service manager instance
     *
     * @param ServiceManager $serviceManager
     * @return User
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        return $this;
    }
}
