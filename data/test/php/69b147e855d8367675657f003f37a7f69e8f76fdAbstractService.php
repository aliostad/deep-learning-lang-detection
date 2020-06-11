<?php

/**
 * Abstract Service
 * 
 * @category    ResponsiveImage
 * @package     Service
 * @author      Peter Hough <peterh@mnatwork.com>
 */

namespace ResponsiveImage\Service;

use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\ServiceManager;

abstract class AbstractService implements ServiceManagerAwareInterface
{    
    /**
     * @var \Zend\ServiceManager\ServiceManager 
     */
    protected $serviceManager;
    
    /**
     * Retrieve service manager instance
     *
     * @return \Zend\ServiceManager\ServiceManager
     */
    public function getServiceManager()
    {
        return $this->serviceManager;
    }
    
    /**
     * Set service manager instance
     *
     * @param \Zend\ServiceManager\ServiceManager $serviceManager
     * @return BaseService
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        return $this;
    }

}
