<?php

namespace UnitTest\NumberTwo;

use NumberTwo\NumberTwo;

class ScalarDumpTest extends \PHPUnit_Framework_TestCase
{
    public function testDumpNull()
    {
        $dump = NumberTwo::dump(null);
        $this->assertEquals('null', $dump);
    }

    public function testDumpInt()
    {
        $dump = NumberTwo::dump(1);
        $this->assertEquals('1', $dump);
        $dump = NumberTwo::dump(-1);
        $this->assertEquals('-1', $dump);
    }

    public function testDumpFloat()
    {
        $dump = NumberTwo::dump(1.04);
        $this->assertEquals('1.04', $dump);
        $dump = NumberTwo::dump(-1.04);
        $this->assertEquals('-1.04', $dump);
        $dump = NumberTwo::dump(1.0);
        $this->assertEquals('1.0', $dump);
    }

    public function testDumpString()
    {
        $dump = NumberTwo::dump('some string');
        $this->assertEquals('"some string"', $dump);

        $str = <<<END
This is a
  multiline string
END;
        $expected = <<<END
"This is a
  multiline string"
END;
        $dump = NumberTwo::dump($str);
        $this->assertEquals($expected, $dump);
    }

    public function testDumpBoolean()
    {
        $dump = NumberTwo::dump(false);
        $this->assertEquals('false', $dump);
        $dump = NumberTwo::dump(true);
        $this->assertEquals('true', $dump);
    }
}
