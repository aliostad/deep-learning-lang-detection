<?php

namespace SlidesWorkerTest\ServiceLocator\Initializer;

use SlidesWorker\ServiceLocator\ServiceLocator;
use SlidesWorker\ServiceLocator\Initializer\ServiceLocatorInitializer;
use SlidesWorkerTest\ServiceLocator\TestAsset\ServiceLocatorAwareClass;

class ServiceLocatorInitializerTest extends \PHPUnit_Framework_TestCase
{
    protected $SUT;
    protected $locator;

    public function setup()
    {
        $this->SUT = new ServiceLocatorInitializer();
        $this->locator = new ServiceLocator();
    }

    public function testInitialize ()
    {
        $instance = new ServiceLocatorAwareClass();

        $this->assertInstanceOf('SlidesWorker\ServiceLocator\ServiceLocatorAwareInterface', $instance);

        $this->SUT->initialize($instance, $this->locator);
    }
}
