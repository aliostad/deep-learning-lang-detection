<?php

namespace Serenity\Common;

/**
 * Universal service manager.
 * Provides functionality for loading services with their dependencies.
 *
 * @category Serenity
 * @package  Common
 */
class ServiceManager
{
    /**
     * @var array A list of registered services.
     */
    private $services = array();

    /**
     * @var array An array of service instances.
     *            Makes sure that a service instance is created only once.
     */
    private $serviceInstances = array();

    /**
     * Get a service by its name.
     *
     * @param string $serviceName The service name.
     *
     * @return object The requested service instance.
     *
     * @throws ServiceManagerException If the requested service is not
     *                                 registred or the service class
     *                                 does not exist.
     */
    public function __get($serviceName)
    {
        return $this->getService($serviceName);
    }

    /**
     * Register a service into the service manager.
     *
     * @param string $serviceName Name of the service.
     * @param string $class       The service's class.
     * @param array  $args        An array of the service constructor arguments.
     * @param array  $calls       An array of the service calls being called
     *                            after the service is created.
     *
     * @return ServiceManager Self instance.
     */
    public function registerService($serviceName, $class, array $args = array(),
        array $calls = array())
    {
        $serviceName = (string) $serviceName;

        $this->services[$serviceName] = array(
            'class' => \ltrim((string) $class, '\\'),
            'args' => $args,
            'calls' => $calls
        );

        unset($this->serviceInstances[$serviceName]);

        return $this;
    }

    /**
     * Register a list services into the service manager.
     *
     * @param array $services A list of services.
     *
     * @return ServiceManager Self instance.
     */
    public function registerServices(array $services)
    {
        foreach ($services as $serviceName => $service) {
            $class = $service['class'];
            $args = isset($service['args']) ? $service['args'] : array();
            $calls = isset($service['calls']) ? $service['calls'] : array();

            $this->registerService(
                $serviceName, $class, (array) $args, (array) $calls
            );
        }

        return $this;
    }

    /**
     * Check if the given service is registered.
     *
     * @param string $serviceName The service name.
     *
     * @return bool Returns true if the service is registered, false otherwise.
     */
    public function isServiceRegistred($serviceName)
    {
        return isset($this->services[(string) $serviceName]);
    }

    /**
     * Create a new service.
     *
     * @param string $class The service's class.
     * @param array  $args  An array of the service constructor arguments.
     *
     * @return mixed The requested service instance.
     *
     * @throws ServiceManagerException
     */
    public function createService($class, array $args = array())
    {
        $class = (string) $class;
        if (!\class_exists($class)) {
            $message = "Class '$class' does not exist.";
            throw new ServiceManagerException($message);
        }

        if (!empty($args)) {
            $reflection = new \ReflectionClass($class);
            $args = $this->_replaceArgPlaceholders($args);

            return $reflection->newInstanceArgs($args);
        } else {
            return new $class();
        }
    }

    /**
     * Get a service by its name.
     *
     * @param string $serviceName The service name.
     *
     * @return object The requested service instance.
     *
     * @throws ServiceManagerException If the requested service is not
     *                                 registred or the service class
     *                                 does not exist.
     */
    public function getService($serviceName)
    {
        $serviceName = (string) $serviceName;

        if (!$this->isServiceRegistred($serviceName)) {
            $message = "Service '$serviceName' is not registered.";
            throw new ServiceManagerException($message);
        }

        if (!isset($this->serviceInstances[$serviceName])) {
            $class = $this->services[$serviceName]['class'];
            $args = $this->services[$serviceName]['args'];
            $calls = $this->services[$serviceName]['calls'];

            $service = $this->createService($class, $args);
            foreach ($calls as $method => $args) {
                $args = $this->_replaceArgPlaceholders((array) $args);
                \call_user_func_array(array($service, $method), $args);
            }

            $this->serviceInstances[$serviceName] = $service;

            return $service;
        }

        return $this->serviceInstances[$serviceName];
    }

    /**
     * Get a service by its class.
     *
     * @param string $serviceClass The service class.
     *
     * @return object The requested service instance.
     *
     * @throws ServiceManagerException If the requested service is not
     *                                 registred or the service class
     *                                 does not exist.
     */
    public function getServiceByClass($serviceClass)
    {
        $serviceClass = (string) $serviceClass;

        foreach ($this->services as $name => $service) {
            if ($serviceClass === $service['class']) {
                return $this->getService($name);
            }
        }

        foreach ($this->serviceInstances as $service) {
            if ($service instanceof $serviceClass) {
                return $service;
            }
        }

        foreach ($this->services as $name => $service) {
            if (\is_subclass_of($service['class'], $serviceClass)) {
                return $this->getService($name);
            }
        }

        $message = "Service of class '$serviceClass' is not registered.";
        throw new ServiceManagerException($message);
    }

    protected function _replaceArgPlaceholders(array $args)
    {
        $self = $this;
        \array_walk_recursive($args, function(&$arg) use ($self) {
            if (\is_string($arg) && '@' === \substr($arg, 0, 1)) {
                $arg = ('@this' !== $arg)
                    ? $self->getService(\substr($arg, 1))
                    : $self;
            }
        });

        return $args;
    }
}