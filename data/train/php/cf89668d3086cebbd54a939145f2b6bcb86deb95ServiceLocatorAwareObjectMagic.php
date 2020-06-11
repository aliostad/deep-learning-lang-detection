<?php
/**
 * Created by Dmitry Prokopenko <hellsigner@gmail.com>
 * Date: 03.06.15
 * Time: 12:16
 */

namespace ModelMagic\Entity;

use Zend\ServiceManager\ServiceLocatorAwareInterface;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceLocatorAwareObjectMagic extends ModelMagic implements ServiceLocatorAwareInterface
{

    protected $serviceLocator;

    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     * @return $this
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
        return $this;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    public function __debuginfo()
    {
        return array($this->fields, 'serviceLocator' => '[Object]');
    }
}
