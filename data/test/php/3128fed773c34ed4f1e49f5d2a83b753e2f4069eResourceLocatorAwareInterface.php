<?php

/**
 * Parrot Framework
 *
 * @author Jason Brown <jason.brown@parrotcageapps.com>
 */

namespace Parrot\API\Resource\Service;

/**
 * Interface ResourceLocatorAwareInterface
 * @package Parrot\API\Resource\Service
 */
interface ResourceLocatorAwareInterface
{
    /**
     * Set Resource Locator Service
     *
     * @param ResourceLocator $resourceLocator
     */
    public function setResourceLocatorService(ResourceLocator $resourceLocator);

    /**
     * Get Resource Locator Service
     *
     * @return ResourceLocator
     */
    public function getResourceLocatorService();
} 