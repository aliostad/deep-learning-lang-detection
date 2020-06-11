<?php

require_once __DIR__ . '/stubs/BadFacade.php';
require_once __DIR__ . '/stubs/CustomResolver.php';
require_once __DIR__ . '/stubs/Foo.php';
require_once __DIR__ . '/stubs/FooFacade.php';
require_once __DIR__ . '/stubs/GiveMeAFooFacade.php';

use LordMonoxide\Facade\Facade;

class FacadeTest extends PHPUnit_Framework_TestCase {
  public function testFacade() {
    $this->assertEquals('bar', FooFacade::getBar());
    $this->assertEquals('bar', FooFacade::returnThisVar('bar'));
  }
  
  public function testBadFacade() {
    $this->setExpectedException('InvalidArgumentException');
    $bar = BadFacade::test();
  }
  
  public function testCustomResolver() {
    $phi = LordMonoxide\Phi\Phi::instance();
    $phi->addResolver(new CustomResolver);
    
    $this->assertEquals('bar', GiveMeAFooFacade::getBar());
    $this->assertEquals('bar', FooFacade::getBar());
  }
}
