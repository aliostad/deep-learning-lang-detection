<?php
namespace Lulu\Imageboard\ServiceManager\Component;

use Lulu\Imageboard\ServiceManager\FactoryInterface;

class Definitions
{
    /**
     * Map {ServiceName => ServiceFactoryClassName}
     * @var string[]
     */
    private $factories = [];

    /**
     * Define service factory for service
     * @param $serviceName
     * @param $serviceFactoryName
     */
    public function defineServiceFactory($serviceName, $serviceFactoryName)
    {
        $this->factories[$serviceName] = $serviceFactoryName;
    }

    /**
     * Returns true if there is defined service factory for service
     * @param $serviceName
     * @return bool
     */
    public function hasDefinedServiceFactoryForService($serviceName)
    {
        return isset($this->factories[$serviceName]);
    }

    /**
     * Create and returns service factory
     * @param $serviceName
     * @return FactoryInterface
     */
    public function createServiceFactory($serviceName)
    {
        if($this->hasDefinedServiceFactoryForService($serviceName)) {
            return new $this->factories[$serviceName];
        }else{
            throw new \OutOfBoundsException(sprintf('No factory available for service `%s`', $serviceName));
        }
    }
}