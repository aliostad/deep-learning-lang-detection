<?php

namespace SpotOnLive\LaravelZf2FormTest\Facades\Helpers;

use PHPUnit_Framework_TestCase;

class FormHelperFacadeTest extends PHPUnit_Framework_TestCase
{
    /** @var \SpotOnLive\Navigation\Facades\Helpers\FormHelperFacade */
    protected $facade;

    public function setUp()
    {
        $facade = new \SpotOnLive\LaravelZf2Form\Facades\Helpers\FormHelperFacade();
        $this->facade = $facade;
    }

    public function testMethodGetFacadeAccessor()
    {
        $method = $this->getMethod('getFacadeAccessor');
        $obj = new $this->facade;
        $result = $method->invokeArgs($obj, []);

        $this->assertEquals('SpotOnLive\LaravelZf2Form\Helpers\FormHelper', $result);
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
