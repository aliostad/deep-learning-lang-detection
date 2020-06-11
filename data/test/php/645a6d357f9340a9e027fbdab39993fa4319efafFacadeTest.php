<?php namespace C4tech\Test\Support\Test;

use C4tech\Support\Test\Facade;
use PHPUnit_Framework_TestCase as TestCase;
use ReflectionClass;

class FacadeTest extends TestCase
{
    public function setUp()
    {
        $this->object = new  Facade;
    }
    public function testFacadeAccessor()
    {
        $facade = 'C4tech\Test\Support\Test\MockFacade';
        $accessor = 'test.facade';

        $reflection = new ReflectionClass($this->object);
        $setter = $reflection->getProperty('facade');
        $setter->setAccessible(true);
        $setter->setValue($this->object, $facade);

        $method = $reflection->getMethod('verifyFacadeAccessor');
        $method->setAccessible(true);
        $method->invoke($this->object, $accessor);
    }
}
