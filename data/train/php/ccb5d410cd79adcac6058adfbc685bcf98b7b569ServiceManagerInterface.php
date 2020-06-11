<?php

namespace Axon\Core\Service;

interface ServiceManagerInterface
{

    /**
     * Set factory instance.
     * @param string $serviceName
     * @param ServiceFactoryInterface | callable $factory
     * @return ServiceManagerInterface
     */
    public function setFactory($serviceName, $factory);

    /**
     * Get factory by name.
     * @param string $serviceName
     * @throws ServiceException
     * @return ServiceFactoryInterface
     */
    public function getFactory($serviceName);

    /**
     * Has factory by name?
     * @param string $serviceName
     * @return boolean
     */
    public function hasFactory($serviceName);

    /**
     * Remove factory by name.
     * @param string $serviceName
     * @return ServiceManagerInterface
     */
    public function removeFactory($serviceName);

    /**
     * Set service instance.
     * @param string $serviceName
     * @param object $service
     * @return ServiceManagerInterface
     */
    public function setService($serviceName, $service);

    /**
     * Get or create service instance.
     * @throws ServiceException
     * @return object
     */
    public function getService($serviceName);

    /**
     * Has service by name?
     * @param string $serviceName
     * @return boolean
     */
    public function hasService($serviceName);

    /**
     * Remove service by name.
     * @param string $serviceName
     * @return ServiceManagerInterface
     */
    public function removeService($serviceName);

}
