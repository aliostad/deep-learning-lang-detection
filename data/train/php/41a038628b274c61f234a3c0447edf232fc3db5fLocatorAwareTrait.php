<?php

namespace WebinoDomLib\Dom;

/**
 * Class LocatorAwareTrait
 */
trait LocatorAwareTrait
{
    /**
     * @var Locator
     */
    private $locator;

    /**
     * @return Locator
     */
    protected function getLocator()
    {
        if (null === $this->locator) {
            $this->setLocator(new Locator);
        }
        return $this->locator;
    }

    /**
     * @param Locator $locator
     * @return self
     */
    public function setLocator(Locator $locator)
    {
        $this->locator = $locator;
        return $this;
    }
}
