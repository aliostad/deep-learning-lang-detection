<?php

namespace SpotOnMarketing\NavigationTest\Facades\Helpers;

use PHPUnit_Framework_TestCase;

class NavigationHelperFacadeTest extends PHPUnit_Framework_TestCase
{
    /** @var \SpotOnMarketing\Navigation\Facades\Helpers\NavigationHelperFacade */
    protected $facade;

    public function setUp()
    {
        $facade = new \SpotOnMarketing\Navigation\Facades\Helpers\NavigationHelperFacade();
        $this->facade = $facade;
    }

    public function testMethodGetFacadeAccessor()
    {
        $method = $this->getMethod('getFacadeAccessor');
        $obj = new $this->facade;
        $result = $method->invokeArgs($obj, []);

        $this->assertEquals('SpotOnMarketing\Navigation\Helpers\NavigationHelper', $result);
    }

    /**
     * Get protected/private method from facade
     *
     * @param $name
     * @return \ReflectionMethod
     */
    protected function getMethod($name)
    {
        $class = new \ReflectionClass(get_class($this->facade));

        $method = $class->getMethod($name);
        $method->setAccessible(true);

        return $method;
    }
}
