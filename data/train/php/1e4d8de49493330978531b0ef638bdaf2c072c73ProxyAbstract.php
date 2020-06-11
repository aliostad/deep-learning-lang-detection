<?php


namespace SoPhp\Rpc\Proxy;


use SoPhp\Rpc\Client;
use SoPhp\Rpc\ServiceAwareInterface;
use SoPhp\Rpc\ServiceInterface;

abstract class ProxyAbstract implements ServiceAwareInterface {
    /** @var  ServiceInterface */
    private $service;
    /**
     * @param ServiceInterface $service
     */
    public function __setService(ServiceInterface $service)
    {
        $this->service = $service;
    }

    /**
     * @return ServiceInterface
     */
    public function __getService()
    {
        return $this->service;
    }

    /**
     * @param string $name
     * @param array $params
     * @return mixed
     */
    public function __call($name, $params){
        return $this->__getService()->call($name, $params);
    }
}