<?php

class CustomerTest extends PHPUnit_Framework_TestCase {

    public function testCanBeCreated() {
        $customer = new Customer();
        $this->assertInstanceOf('Customer', $customer, "customer is not a Customer!");
    }

    public function testCanAddName() {
        $customer = new Customer();
        $customer->addName('Gabriel Guzman');
    }

    public function testCanGetName() {
        $customer = new Customer();
        $customer->addName('Gabriel Guzman');
        $this->assertEquals('Gabriel Guzman', $customer->getName());
    }
}
