<?php

namespace Pagekit\Component\File\StreamWrapper;

use Pagekit\Component\File\ResourceLocator;

class ResourceLocatorBasedReadOnlyStreamWrapper extends ReadOnlyStreamWrapper
{
    /**
     * @var ResourceLocator
     */
    protected static $locator;

    /**
     * @param ResourceLocator $locator
     */
    public static function setLocator(ResourceLocator $locator)
    {
        self::$locator = $locator;
    }

    /**
     * {@inheritdoc}
     */
    protected function getTarget($uri)
    {
        return self::$locator->findResource($uri);
    }
}
