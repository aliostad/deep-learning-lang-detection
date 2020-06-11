<?php
namespace Lulu\Imageboard\ServiceManager\Component;

class Services
{
    /**
     * Map {ServiceName => ServiceObject}
     * @var object[]
     */
    private $services = [];

    /**
     * Add service
     * @param $serviceName
     * @param $service
     */
    public function addService($serviceName, $service) {
        $this->services[$serviceName] = $service;
    }

    /**
     * Returns true if service exists
     * @param $serviceName
     * @return bool
     */
    public function hasServiceWithName($serviceName) {
        return isset($this->services[$serviceName]);
    }

    /**
     * Returns service
     * @param $serviceName
     * @return object
     */
    public function getService($serviceName) {
        if($this->hasServiceWithName($serviceName)) {
            return $this->services[$serviceName];
        }else{
            throw new \OutOfBoundsException(sprintf('No service with name `%s` available'));
        }
    }
}