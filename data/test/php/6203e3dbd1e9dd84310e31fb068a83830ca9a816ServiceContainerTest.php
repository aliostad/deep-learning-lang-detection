<?php

namespace LaraibaTest\Resource\ServiceContainer;

use Laraiba\Resource\ServiceContainer\ServiceContainer;

class ServiceContainerTest extends \PHPUnit_Framework_TestCase
{
    protected $serviceContainer;

    public function setUp()
    {
        $this->serviceContainer = new ServiceContainer();
    }

    public function testImplementsServiceContainerInterface()
    {
        $this->assertInstanceOf(
            'Laraiba\Resource\ServiceContainer\ServiceContainerInterface',
            $this->serviceContainer
        );
    }

    public function testHasService()
    {
        $this->assertFalse($this->serviceContainer->has('now'));
        $this->serviceContainer['now'] = new \DateTime();
        $this->assertTrue($this->serviceContainer->has('now'));
    }

    public function testGetService()
    {
        $serviceContainer = $this->serviceContainer;

        $serviceContainer['now'] = function ($c) {
            return new \DateTime();
        };

        $this->assertInstanceOf('DateTime', $serviceContainer->get('now'));
    }
}
