<?php
/**
 * Spiral, Core Components
 *
 * @author Wolfy-J
 */

namespace Spiral\Tests\Debug;

use Mockery as m;
use Psr\Log\LoggerInterface;
use Spiral\Debug\Dumper;

class DumperTest extends \PHPUnit_Framework_TestCase
{
    public function testDumpIntoBuffer()
    {
        $dumper = new Dumper();

        ob_start();
        $dumper->dump(1);
        $result = ob_get_clean();

        $this->assertSame($dumper->dump(1, Dumper::OUTPUT_RETURN), $result);
    }

    public function testDumpScalar()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump(123, Dumper::OUTPUT_RETURN);

        $this->assertContains('123', $dump);
    }

    public function testDumpScalarString()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump('test-string', Dumper::OUTPUT_RETURN);

        $this->assertContains('test-string', $dump);
    }

    public function testDumpScalarStringEscaped()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump('test<>string', Dumper::OUTPUT_RETURN);

        $this->assertContains('test&lt;&gt;string', $dump);
    }

    public function testDumpArray()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump(['G', 'B', 'N'], Dumper::OUTPUT_RETURN);

        $this->assertContains('array', $dump);
        $this->assertContains('G', $dump);
        $this->assertContains('B', $dump);
        $this->assertContains('N', $dump);
    }

    public function testDumpAnonClass()
    {
        $dumper = new Dumper();
        $dumper->setStyle(new Dumper\InversedStyle());

        $dump = $dumper->dump(new class
        {
            private $name = 'Test';
        }, Dumper::OUTPUT_RETURN);

        $this->assertContains('object', $dump);
        $this->assertContains('private', $dump);
        $this->assertContains('name', $dump);
        $this->assertContains('string(4)', $dump);
        $this->assertContains('test', $dump);
    }

    protected $_value_ = 'test value';

    /**
     * @invisible
     * @var string
     */
    protected $_invisible_ = 'invisible value';

    public function testDumpObject()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump($this, Dumper::OUTPUT_RETURN);

        $this->assertContains(self::class, $dump);
        $this->assertNotContains('invisible value', $dump);
        $this->assertContains('_value_', $dump);

        $this->assertContains('test value', $dump);
        $this->assertNotContains('_invisible_', $dump);
    }

    public function testDumpObjectOtherStyle()
    {
        $dumper = new Dumper(10, new Dumper\InversedStyle());

        $dump = $dumper->dump($this, Dumper::OUTPUT_RETURN);

        $this->assertContains(self::class, $dump);
        $this->assertNotContains('invisible value', $dump);
        $this->assertContains('_value_', $dump);

        $this->assertContains('test value', $dump);
        $this->assertNotContains('_invisible_', $dump);
    }

    public function testDumpObjectDebugInfo()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump(new class
        {
            protected $_inner_ = '_kk_';

            public function __debugInfo()
            {
                return [
                    '_magic_' => '_value_'
                ];
            }

        }, Dumper::OUTPUT_RETURN);

        $this->assertContains('_magic_', $dump);
        $this->assertContains('_value_', $dump);

        $this->assertNotContains('_inner_', $dump);
        $this->assertNotContains('_kk_', $dump);
    }

    public function testDumpClosure()
    {
        $dumper = new Dumper();

        $dump = $dumper->dump(function () {
            echo 'hello world';
        }, Dumper::OUTPUT_RETURN);

        $this->assertContains('Closure', $dump);
        $this->assertContains('DumperTest.php', $dump);
    }

    public function testDumpToLog()
    {
        $logger = m::mock(LoggerInterface::class);
        $dumper = new Dumper(10, null, $logger);

        $logger->shouldReceive('debug')->with(
            $dumper->dump('abc', Dumper::OUTPUT_RETURN)
        );

        $dumper = new Dumper(10, null, $logger);

        $dumper->dump('abc', Dumper::OUTPUT_LOG);
    }
}