<?php
/**
 * @author stev leibelt <artodeto@bazzline.net>
 * @since 2015-09-08
 */
namespace Net\Bazzline\UniqueNumberRepository\Application\Service;

use Net\Bazzline\Component\Locator\FactoryInterface;
use Net\Bazzline\Component\Locator\LocatorInterface;

class UniqueNumberEnumeratorFactory implements FactoryInterface
{
    /**
     * @var ApplicationLocator
     */
    private $locator;

    /**
     * @param LocatorInterface $locator
     * @return $this
     */
    public function setLocator(LocatorInterface $locator)
    {
        $this->locator = $locator;

        return $this;
    }

    /**
     * @return NumberEnumerator
     */
    public function create()
    {
        return new NumberEnumerator($this->locator->getUniqueNumberStorage());
    }
}
