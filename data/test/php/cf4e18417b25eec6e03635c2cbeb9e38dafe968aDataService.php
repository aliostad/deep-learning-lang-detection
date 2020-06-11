<?php

namespace Phine\Locator\Service;

use ArrayObject;
use Phine\Locator\LocatorInterface;

/**
 * Allows data to be shared among services.
 *
 * @author Kevin Herrera <kevin@herrera.io>
 */
class DataService extends ArrayObject implements ServiceInterface
{
    /**
     * The service locator.
     *
     * @var LocatorInterface
     */
    protected $locator;

    /**
     * Returns the service locator.
     *
     * @return LocatorInterface The service locator.
     */
    public function getLocator()
    {
        return $this->locator;
    }

    /**
     * {@inheritDoc}
     */
    public function setLocator(LocatorInterface $locator)
    {
        $this->locator = $locator;
    }
}
