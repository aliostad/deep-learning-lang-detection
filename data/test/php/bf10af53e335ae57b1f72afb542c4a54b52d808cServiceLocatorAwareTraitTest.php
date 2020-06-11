<?php

namespace SlidesWorkerTest\ServiceLocator;

use SlidesWorker\ServiceLocator\ServiceLocator;
use SlidesWorkerTest\ServiceLocator\TestAsset\ServiceLocatorAwareClass;

class ServiceLocatorAwareTraitTest extends \PHPUnit_Framework_TestCase
{
    /**
     * @var \SlidesWorker\ServiceLocator\ServiceLocatorAwareTrait
     */
    protected $SUT;

    public function setup()
    {
        $this->locator = new ServiceLocator();
        $this->SUT = new ServiceLocatorAwareClass();
    }

    public function testTraitObject ()
    {
        $this->SUT->setServiceLocator($this->locator);

        $this->assertSame($this->locator, $this->SUT->getServiceLocator());
    }
}
