<?php

class FacadeTests extends PHPUnit_Framework_TestCase
{
    public function testSetFacadeObject()
    {
        $object = $this->getMock('Any');

        Facade::__setFacadeObject($object);
        $this->assertEquals($object, Facade::__getFacadeObject());
    }

    public function testFacadeObjectMethod()
    {
        $object = $this->getMock('Any', ['someMethod']);
        $object->expects($this->any())
               ->method('someMethod')
               ->will($this->returnValue("value"));

        Facade::__setFacadeObject($object);
        $this->assertEquals("value", Facade::someMethod());
    }
}