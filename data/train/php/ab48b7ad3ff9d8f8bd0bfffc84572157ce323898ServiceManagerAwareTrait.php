<?php

namespace Protec\ZF2Trait\ServiceManager;

use \Zend\ServiceManager\ServiceManager;

/**
 * ServiceManagerAwareTrait
 *
 * @package   Protec\ZF2Trait\ServiceManager
 * @author    Protec Innovations <support@protecinnovations.co.uk>
 * @copyright 2012 Protec Innovations
 */
trait ServiceManagerAwareTrait
{
    /**
     * @var \Zend\ServiceManager\ServiceManager
     */
    protected $service_manager = null;

    /**
     * setServiceManager
     *
     * @param \Zend\ServiceManager\ServiceManager $serviceManager
     * @return
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->service_manager = $serviceManager;

        return $this;
    }
}
