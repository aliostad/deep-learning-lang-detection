<?php

namespace MiniFrame;

abstract class BaseService
{
    /**
     * @var ServiceLoader
     */
    protected $serviceLoader;

    /**
     * @param ServiceLoader $serviceLoader
     */
    public function __construct(ServiceLoader $serviceLoader)
    {
        $this->serviceLoader = $serviceLoader;
    }

    /**
     * @return ServiceLoader
     */
    public function getServiceLoader()
    {
        return $this->serviceLoader;
    }

    /**
     * @return Config
     */
    public function getConfigs()
    {
        return $this->getServiceLoader()->getConfigs();
    }

    /**
     * @param $name
     * @return BaseService
     */
    public function getService($name)
    {
        return $this->getServiceLoader()->getService($name);
    }

    public function init()
    {

    }
}
