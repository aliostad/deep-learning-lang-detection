<?php

namespace AZ\Framework\Kernel;

class Service{

  protected $services = array();

  public function __construct($services){
    foreach($services as $serviceName => $service){
      $this->set($serviceName, $service);  
    } 
  }

  public function get($serviceName){
    return array_key_exists($serviceName, $this->services) ? $this->services[$serviceName] : null;
  }

  public function set($serviceName, $service){
    $this->services[$serviceName] = $service;
  }

  function __get($serviceName){
    return $this->get($serviceName);
  }

  function __set($serviceName, $service){
    $this->set($serviceName, $service);  
  }

}
?>