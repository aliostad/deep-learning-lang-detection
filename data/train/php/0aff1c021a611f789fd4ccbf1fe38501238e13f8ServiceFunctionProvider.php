<?php

namespace BnpServiceDefinition\Dsl\Extension;

use BnpServiceDefinition\Dsl\Extension\Feature\FunctionProviderInterface;
use BnpServiceDefinition\Exception;
use Zend\ServiceManager\Exception\ServiceNotCreatedException;
use Zend\ServiceManager\Exception\ServiceNotFoundException;
use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceFunctionProvider implements
    FunctionProviderInterface,
    ServiceLocatorAwareInterface
{
    const SERVICE_KEY = 'BnpServiceDefinition\Dsl\Extension\ServiceFunctionProvider';

    /**
     * @var string
     */
    protected $serviceName;

    /**
     * @var ServiceLocatorInterface
     */
    protected $services;

    public function __construct($serviceName = null)
    {
        $this->serviceName = null === $serviceName ? static::SERVICE_KEY : $serviceName;
    }

    public function getName()
    {
        return 'service';
    }

    public function getEvaluator(array $context = array())
    {
        $self = $this;
        return function ($args, $service, $silent = false, $instance = null) use ($self) {
            return $self->getService($service, $silent, $instance);
        };
    }

    public function getCompiler()
    {
        $serviceName = $this->serviceName;
        return function ($service, $silent = false, $instance = null) use ($serviceName) {
            if ('false' === strtolower($silent)) {
                $silent = false;
            }
            $silent = $silent ? 'true' : 'false';
            if (! $instance) {
                $instance = 'null';
            } elseif ('\\' !== substr($instance, 1, 1)) {
                $instance = $instance[0] . '\\' . substr($instance, 1);
            }

            return sprintf(
                '$this->services->get(\'%s\')->getService(%s, %s, %s)',
                $serviceName,
                $service,
                $silent,
                $instance
            );
        };
    }

    protected function getServiceFromLocator(ServiceLocatorInterface $services, $name, $silent = false, $instance = null)
    {
        $service = null;
        try {
            $service = $services->get($name);
        } catch (ServiceNotFoundException $e) {
            if (! $silent) {
                throw $e;
            }
        } catch (ServiceNotCreatedException $e) {
            if (! $silent) {
                throw $e;
            }
        }

        if (null !== $service && null !== $instance and ! is_object($service) || ! $service instanceof $instance) {
            throw new Exception\RuntimeException(sprintf(
                'Expected  a "%s" service instance, "%s" received',
                $instance,
                is_object($service) ? get_class($service) : gettype($service)
            ));
        }

        return $service;
    }

    public function getService($name, $silent = false, $instance = null)
    {
        return $this->getServiceFromLocator($this->getServiceLocator(), $name, $silent, $instance);
    }

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->services = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->services;
    }
}
