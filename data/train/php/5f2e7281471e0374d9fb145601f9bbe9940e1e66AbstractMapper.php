<?php
/**
 * MaiMai Service
 *
 * @link         https://github.com/digila/MaiMaiService
 * @copyright (c) 2014-2015 DigiLa Web Create Studio.
 * @license     MIT (http://opensource.org/licenses/mit-license.php)
 */

namespace MaiMaiService\Mapper;

use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\ServiceManager;

abstract class AbstractMapper implements ServiceManagerAwareInterface
{
    protected $serviceManager;

    /**
     * Set service manager instance
     *
     * @param ServiceManager $serviceManager
     * @return Service
     */
    public function setServiceManager(ServiceManager $serviceManager)
    {
        $this->serviceManager = $serviceManager;
        return $this;
    }

    public function getServiceManager()
    {
        return $this->serviceManager;
    }
}
