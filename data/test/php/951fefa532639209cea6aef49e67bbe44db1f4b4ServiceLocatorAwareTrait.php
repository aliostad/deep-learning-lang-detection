<?php
namespace SynergyCommon\Service;

use Interop\Container\ContainerInterface;

/**
 * Class ServiceLocatorAwareTrait
 * @package SynergyCommon\Service
 */
trait ServiceLocatorAwareTrait
{
    /**
     * @var ContainerInterface
     */
    protected $serviceLocator;

    /**
     * @return ContainerInterface
     */
    public function getServiceLocator()
    {
        return $this->serviceLocator;
    }

    /**
     * @param mixed $serviceLocator
     */
    public function setServiceLocator(ContainerInterface $serviceLocator)
    {
        $this->serviceLocator = $serviceLocator;
    }
}
