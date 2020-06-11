<?php


namespace SoPhp\ServiceRegistry;


use SoPhp\Amqp\EndpointDescriptor;
use SoPhp\Rpc\ServiceInterface;

class RegistryService implements ServiceInterface {
    /** @var  ServiceInterface */
    protected $service;
    /** @var  ServiceRegistration */
    protected $serviceRegistration;

    function __construct(ServiceInterface $service, ServiceRegistration $serviceRegistration)
    {
        $this->setService($service);
        $this->setServiceRegistration($serviceRegistration);
    }


    /**
     * @return ServiceInterface
     */
    public function getService()
    {
        return $this->service;
    }

    /**
     * @param ServiceInterface $service
     * @return self
     */
    public function setService($service)
    {
        $this->service = $service;
        return $this;
    }

    /**
     * @return ServiceRegistration
     */
    public function getServiceRegistration()
    {
        return $this->serviceRegistration;
    }

    /**
     * @param ServiceRegistration $serviceRegistration
     * @return self
     */
    public function setServiceRegistration($serviceRegistration)
    {
        $this->serviceRegistration = $serviceRegistration;
        return $this;
    }



    /**
     * @param string $name
     * @param array $arguments
     * @return mixed
     */
    public function call($name, $arguments)
    {
        return $this->getService()->call($name, $arguments);
    }

    /**
     * @return EndpointDescriptor
     */
    public function getEndpoint()
    {
        return $this->getService()->getEndpoint();
    }

    /**
     * @param EndpointDescriptor $endpoint
     */
    public function setEndpoint(EndpointDescriptor $endpoint)
    {
        $this->getService()->setEndpoint($endpoint);
    }
}