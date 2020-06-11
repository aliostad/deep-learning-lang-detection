<?php
namespace FzyCommon\Entity\Base;

use FzyCommon\Entity\BaseNull;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceAwareEntityNull extends BaseNull implements ServiceAwareEntityInterface
{
    private $sl;
    /**
     * Set service locator
     *
     * @param ServiceLocatorInterface $serviceLocator
     */
    public function setServiceLocator(ServiceLocatorInterface $serviceLocator)
    {
        $this->sl = $serviceLocator;
    }

    /**
     * Get service locator
     *
     * @return ServiceLocatorInterface
     */
    public function getServiceLocator()
    {
        return $this->sl;
    }
}
