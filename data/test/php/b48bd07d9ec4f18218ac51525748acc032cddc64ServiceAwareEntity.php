<?php
namespace FzyCommon\Entity\Base;

use FzyCommon\Entity\Base;
use Zend\ServiceManager\ServiceLocatorInterface;

class ServiceAwareEntity extends Base implements ServiceAwareEntityInterface
{
    /**
     * @var ServiceLocatorInterface
     */
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
