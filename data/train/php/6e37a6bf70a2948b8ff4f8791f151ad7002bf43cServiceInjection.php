<?php

namespace Nano\Behavior;

use Nano\Service\ServiceManagerInterface;

trait ServiceInjection
{
    /**
     * @var ServiceManagerInterface
     */
    private $_serviceManager;

    /**
     * @param \Nano\Service\ServiceManagerInterface $serviceManager
     *
     * @return $this
     */
    public function setServiceManager($serviceManager)
    {
        $this->_serviceManager = $serviceManager;

        return $this;
    }

    /**
     * @return \Nano\Service\ServiceManagerInterface
     */
    public function getServiceManager()
    {
        return $this->_serviceManager;
    }


}