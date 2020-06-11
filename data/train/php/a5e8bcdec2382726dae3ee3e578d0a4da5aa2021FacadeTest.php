<?php namespace Rework\Support\Facades;

class FacadeTest extends \PHPUnit_Framework_TestCase
{
    public function testChildLoad()
    {
        $child = FacadeChildTest::load();
        $this->assertTrue(is_object($child));
    }

    /**
     * verify the class is only constructed once
     */
    public function testChildLoadsOnce()
    {
        $child = FacadeChildTest::load();
        $this->assertTrue($child::$count === 1);

        $child = FacadeChildTest::load();
        $this->assertTrue($child::$count === 1);
    }

    public function testChildStaticMethod()
    {
        $this->assertSame(FacadeChildTest::foo(), 'foo');
    }

    public function testChildInstanceMethod()
    {
        $child = FacadeChildTest::load();
        $this->assertSame($child->foo(), 'foo');
    }

    /**
     * @runInSeparateProcess
     */
    public function testShouldReceive()
    {
        FacadeChildTest::shouldReceive('getName')->once()->andReturn('Marky Mark');

        FacadeChildTest::getName();
    }

    /**
     * @runInSeparateProcess
     */
    public function testMockeryMethods()
    {
        FacadeChildTest::shouldReceive('getName')->once()->andReturn('Marky Mark');
        FacadeChildTest::shouldReceive('bar')->once()->andReturn('baz');

        FacadeChildTest::getName();
    }

    /**
     * @runInSeparateProcess
     */
    public function testShouldReceiveCanBeCalledTwice()
    {
        FacadeChildTest::shouldReceive('getName')->andReturn('Marky Mark');
        FacadeChildTest::shouldReceive('getName')->andReturn('Marky Mark');

        FacadeChildTest::getName();
    }

    /**
     * @runInSeparateProcess
     */
    public function testShouldReceiveCanBeCalledAfterLoad()
    {
        FacadeChildTest::load();
        FacadeChildTest::shouldReceive('getName')->andReturn('Marky Mark');

        FacadeChildTest::getName();
    }
}

class FacadeChildTest extends Facade
{
    protected static function getFacadeAccessor()
    {
        return 'Rework\Support\Facades\FacadeImplementationTest';
    }
}

class FacadeImplementationTest
{
    public static $count = 0;

    public function __construct()
    {
        self::$count++;
    }

    public function foo()
    {
        return 'foo';
    }
}
