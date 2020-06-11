<?php

namespace System\DI;

use System\Std\Object;
use System\DI\IContainer;
use System\DI\Service;

class ServiceContainer extends Object implements IContainer {
    
    protected $services = array();
    protected $serviceInstances = array();
    
    public function register($serviceName, $class){
        $service = new Service($this, $serviceName, $class);
        $this->services[$serviceName] = $service;
        return $service;
    }

    public function __get($serviceName){
        return $this->get($serviceName);
    }
    
    public function get($serviceName){
        if($this->hasService($serviceName)){
            $service = $this->services[$serviceName];
            
            if($service->isSingleInstance()){
                
                if(array_key_exists($serviceName, $this->serviceInstances)){
                    return $this->serviceInstances[$serviceName];
                }
                
                $serviceInstance = $service->getInstance();
                $this->serviceInstances[$serviceName] = $serviceInstance;
                return $serviceInstance;
            }
            return $service->getInstance();
        }
        throw new \System\DI\ServiceNotFoundException(sprintf("Service '%s' not found", $serviceName));
    }
    
    public function hasService($serviceName){
        if(array_key_exists($serviceName, $this->services)){
            return true;
        }
        return false;
    }
    
    public function getServices(){
        return $this->services;
    }
}
?>
