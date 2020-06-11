<?php

namespace Application\ServiceManager;

use Zend\ServiceManager\ServiceManager;

trait ServiceManagerAwareTrait
{
    /**
     * @var ServiceManager
     */
    protected $serviceManager;

    /**
     * Устанавливает менеджер сервисов.
     *
     * @param ServiceManager $serviceManager
     *
     * @return $this
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        return $this;
    }

    /**
     * Возвращает менеджер сервисов.
     *
     * @return ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }
}
