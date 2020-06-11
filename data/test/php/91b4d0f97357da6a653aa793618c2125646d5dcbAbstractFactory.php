<?php
/**
 * @author stev leibelt <artodeto@bazzline.net>
 * @since 2015-11-28
 */
namespace Net\Bazzline\TimeRegistration\LocalBuilder\Utility;

use Net\Bazzline\Component\Locator\FactoryInterface;
use Net\Bazzline\Component\Locator\LocatorInterface;

abstract class AbstractFactory implements FactoryInterface
{
    /** @var LocatorInterface|ApplicationLocator */
    private $locator;

    public function setLocator(LocatorInterface $locator)
    {
        $this->locator = $locator;
    }

    /**
     * @return LocatorInterface|ApplicationLocator
     */
    protected function getLocator()
    {
        return $this->locator;
    }
}