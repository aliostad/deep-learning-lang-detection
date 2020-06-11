<?php


namespace SoPhp\ServiceRegistry;

/**
 * Class ServiceRegistryAwareTrait
 * @package SoPhp\ServiceRegistry
 * @satisfies SoPhp\ServiceRegistryAwareInterface
 */
trait ServiceRegistryAwareTrait {
    /** @var  ServiceRegistryInterface */
    private $serviceRegistry;

    /**
     * @param ServiceRegistryInterface $serviceRegistry
     */
    public function setServiceRegistry(ServiceRegistryInterface $serviceRegistry)
    {
        $this->serviceRegistry = $serviceRegistry;
    }

    /**
     * @return ServiceRegistryInterface
     */
    public function getServiceRegistry()
    {
        return $this->serviceRegistry;
    }
} 