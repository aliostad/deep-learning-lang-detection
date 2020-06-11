<?php
namespace TestBox\Framework\ServiceLocator;

use TestBox\Framework\ServiceLocator\service\ServiceInterface;
interface ServiceLocatorInterface
{
    /**
     * Add a Service 
     * 
     * @param string $key
     * @param mixed $service
     */
    public function addService($key,ServiceInterface $service);
    
    /**
     * Define a service
     * 
     * @param array $options
     */
    public function defineService($key, $options);
    
    /**
     * Return a service
     * 
     * @param string $key
     * @return mixed
     */
    public function get($key);
    
    /**
     * Create or set an service alias
     */
    public function addAlias($aliasKey,$targetKey);
    
    /**
     * Cheh if service exists
     * 
     * @param unknown $serviceName
     * @return boolean
     */
    public function hasService($serviceName);
    
    /**
     * Check if service is instantiated
     *
     * @param string $serviceName
     * @return boolean
     */
    public function isInstantiated($serviceName);
}