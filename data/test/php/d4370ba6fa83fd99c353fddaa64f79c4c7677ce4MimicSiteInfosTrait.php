<?php

namespace Grid\Core\Controller\Plugin;

use Zend\ServiceManager\ServiceManager;

/**
 * MimicSiteInfosTrait
 *
 * @author David Pozsar <david.pozsar@megaweb.hu>
 */
trait MimicSiteInfosTrait
{

    /**
     * @var \Zend\ServiceManager\ServiceManager
     */
    protected $serviceManager;

    /**
     * Get service manager
     *
     * @return  ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }

    /**
     * Set service manager
     *
     * @param   ServiceManager  $serviceManager
     * @return  MimicSiteInfos
     */
    public function setServiceManager( ServiceManager $serviceManager )
    {
        $this->serviceManager = $serviceManager;
        return $this;
    }

}
