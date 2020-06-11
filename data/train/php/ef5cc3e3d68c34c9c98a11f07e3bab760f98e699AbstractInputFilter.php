<?php
/**
 * MaiMai Service
 *
 * @link         https://github.com/digila/MaiMaiService
 * @copyright (c) 2014-2015 DigiLa Web Create Studio.
 * @license     MIT (http://opensource.org/licenses/mit-license.php)
 */

namespace MaiMaiService\InputFilter;

use Zend\ServiceManager\ServiceManagerAwareInterface;
use Zend\ServiceManager\ServiceManager;
use Zend\InputFilter\InputFilter;

abstract class AbstractInputFilter extends InputFilter implements ServiceManagerAwareInterface
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
