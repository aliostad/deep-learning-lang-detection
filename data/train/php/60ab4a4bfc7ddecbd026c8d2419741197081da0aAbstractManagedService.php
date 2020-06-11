<?php
namespace SugarLoaf\Service;

class AbstractManagedService
{
  public function __construct($serviceName, $serviceClassRef=false, $parameters=false)
  {
    $this->_serviceName = $serviceName;
    
    if ($serviceClassRef === false)
    {
      $this->_serviceClassRef = $serviceName;
    }
    else
    {
      $this->_serviceClassRef = $serviceClassRef;
    }
    
    $this->_parameters = $parameters;
    
  }
  
  public function getServiceName()
  {
    return $this->_serviceName;
  }
  
}
