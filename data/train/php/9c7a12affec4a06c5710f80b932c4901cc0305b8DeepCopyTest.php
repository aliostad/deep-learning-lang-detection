<?php

use GroupByInc\API\Util\DeepCopy;

class DeepCopyTest extends PHPUnit_Framework_TestCase
{
    public function testSimpleObjectCopy()
    {
        $o = new A();

        $deepCopy = new DeepCopy();

        $this->assertDeepCopyOf($o, $deepCopy->copy($o));
    }

    public function testPropertyScalarCopy()
    {
        $o = new A();
        $o->property1 = 'foo';

        $deepCopy = new DeepCopy();

        $this->assertDeepCopyOf($o, $deepCopy->copy($o));
    }

    public function testPropertyObjectCopy()
    {
        $o = new A();
        $o->property1 = new B();

        $deepCopy = new DeepCopy();

        $this->assertDeepCopyOf($o, $deepCopy->copy($o));
    }

    public function testPropertyArrayCopy()
    {
        $o = new A();
        $o->property1 = [new B()];

        $deepCopy = new DeepCopy();

        $this->assertDeepCopyOf($o, $deepCopy->copy($o));
    }

    public function testCycleCopy1()
    {
        $a = new A();
        $b = new B();
        $c = new B();
        $a->property1 = $b;
        $a->property2 = $c;
        $b->property = $c;

        $deepCopy = new DeepCopy();
        /** @var A $a2 */
        $a2 = $deepCopy->copy($a);

        $this->assertDeepCopyOf($a, $a2);

        $this->assertSame($a2->property1->property, $a2->property2);
    }

    public function testCycleCopy2()
    {
        $a = new B();
        $b = new B();
        $a->property = $b;
        $b->property = $a;

        $deepCopy = new DeepCopy();
        /** @var B $a2 */
        $a2 = $deepCopy->copy($a);

        $this->assertSame($a2, $a2->property->property);
    }

    /**
     * Dynamic properties should be cloned
     */
    public function testDynamicProperties()
    {
        $a = new \stdClass();
        $a->b = new \stdClass();

        $deepCopy = new DeepCopy();
        $a2 = $deepCopy->copy($a);
        $this->assertNotSame($a->b, $a2->b);
        $this->assertDeepCopyOf($a, $a2);
    }

    public function testNonClonableItems()
    {
        $a = new \ReflectionClass('\A');
        $deepCopy = new DeepCopy();
        $a2 = $deepCopy->skipUncloneable()->copy($a);
        $this->assertSame($a, $a2);
    }

    /**
     * @expectedException \Exception
     * @expectedExceptionMessage Class "C" is not cloneable.
     */
    public function testCloneException()
    {
        $o = new \ReflectionClass('\C');
        $deepCopy = new DeepCopy();
        $deepCopy->copy($o);
    }

    protected function assertDeepCopyOf($expected, $actual)
    {
        if (is_null($expected)) {
            $this->assertNull($actual);
            return;
        }
        $this->assertInternalType(gettype($expected), $actual);
        if (is_array($expected)) {
            $this->assertInternalType('array', $actual);
            $this->assertCount(count($expected), $actual);
            foreach ($actual as $i => $item) {
                $this->assertDeepCopyOf($expected[$i], $item);
            }
            return;
        }
        if (!is_object($expected)) {
            $this->assertSame($expected, $actual);
            return;
        }
        $this->assertNotSame($expected, $actual);
        $this->assertInstanceOf(get_class($expected), $actual);
        $class = new \ReflectionClass($actual);
        foreach ($class->getProperties() as $property) {
            $property->setAccessible(true);
            $this->assertDeepCopyOf($property->getValue($expected), $property->getValue($actual));
        }
    }
}

class A
{
    public $property1;
    public $property2;
}

class B
{
    public $property;
}

class C
{
    private function __clone(){}
}