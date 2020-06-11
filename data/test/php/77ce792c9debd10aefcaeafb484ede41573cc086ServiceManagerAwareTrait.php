<?php

namespace Brs\Zf\ServiceManager;

use RuntimeException;
use Zend\ServiceManager\ServiceManager;
use Zend\ServiceManager\ServiceManagerAwareInterface;

trait ServiceManagerAwareTrait
{
    protected $serviceManager;

    public function setServiceManager(ServiceManager $sm)
    {
        $this->serviceManager = $sm;
        return $this;
    }

    public function getServiceManager()
    {
        if (null === $this->serviceManager) {
            throw new RuntimeException('service manager not set');
        }
        return $this->serviceManager;
    }

    public function getService($serviceName)
    {
        return $this->getServiceManager()->get($serviceName);
    }
}