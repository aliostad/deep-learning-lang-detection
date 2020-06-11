<?php

/**
 * Parrot Framework
 *
 * @author Jason Brown <jason.brown@parrotcageapps.com>
 */

namespace Parrot\API\Resource\Service;

/**
 * Class ResourceLocatorAwareTrait
 * @package Parrot\API\Resource\Service
 */
trait ResourceLocatorAwareTrait
{
    /**
     * @var ResourceLocator
     */
    protected $resourceLocator;

    /**
     * Set Resource Locator Service
     *
     * @param ResourceLocator $resourceLocator
     */
    public function setResourceLocatorService(ResourceLocator $resourceLocator)
    {
        $this->resourceLocator = $resourceLocator;
    }

    /**
     * Get Resource Locator Service
     *
     * @return ResourceLocator
     */
    public function getResourceLocatorService()
    {
        return $this->resourceLocator;
    }
} 