<?php

namespace Grid\Core\Controller\Plugin;

use Zend\ServiceManager\ServiceManager;

/**
 * ServicesCopy
 *
 * @author David Pozsar <david.pozsar@megaweb.hu>
 */
class ServicesCopy extends ServiceManager
{

    /**
     * Get service instances
     *
     * @param   ServiceManager $serviceManager
     * @return  array
     */
    public static function getServiceInstances( ServiceManager $serviceManager )
    {
        return $serviceManager->instances;
    }

    /**
     * Set service instances
     *
     * @param   ServiceManager  $serviceManager
     * @param   array           $instances
     * @return  void
     */
    public static function setServiceInstances( ServiceManager $serviceManager, array $instances )
    {
        $serviceManager->instances = $instances;
    }

}
