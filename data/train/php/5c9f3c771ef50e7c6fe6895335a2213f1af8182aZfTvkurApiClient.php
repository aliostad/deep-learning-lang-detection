<?php
/**
 *
 * User: semihs
 * Date: 21.11.14
 * Time: 17:49
 *
 */

namespace ZfTvkurApiClient\View\Helper;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;
use Zend\View\Helper\AbstractHelper;

class ZfTvkurApiClient extends AbstractHelper implements ServiceLocatorAwareInterface {

    protected $serviceLocator;

    /**
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator) {
        $this->serviceLocator = $serviceLocator;
    }

    /**
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator() {
        return $this->serviceLocator;
    }

    public function __invoke() {
        return $this->getServiceLocator()
            ->getServiceLocator()->get('ZfTvkurApiClient');
    }
} 