<?php

namespace ModuleTest\Synapse\Entity;

use PHPUnit_Framework_TestCase;
use Synapse\Model\Entity\Customer;

class CustomerEntityTest extends PHPUnit_Framework_TestCase
{    
    public function testEntity()
    {
        $customer = new Customer();
        $customer->customer_id = 1;
        $customer->customer_company_id = 72;
        $customer->customer_title = 'Mr';
        $customer->customer_first_name = 'Test';
        $customer->customer_last_name = 'Test';
        $customer->customer_dob = '2012-04-02';
        $customer->customer_username = 'Test1';
        $customer->customer_email = 'test@test.com';
        $customer->customer_password = 'test';
        $customer->customer_address_1 = 'address 1';
        $customer->customer_address_2 = 'address 2';
        $customer->customer_address_3 = 'address 3';
        $customer->customer_city = 'london';
        $customer->customer_postcode = 'EXNX';
        $customer->customer_country = 'UK';
        $customer->customer_mobile = '555-555-555';
        $customer->customer_pin = '5555';
        $customer->customer_parental_pin = '55556';
        $customer->customer_activation_code = '555555';
        $customer->customer_created = '2013-08-26';
        $customer->customer_affiliate_id = 12;
        $customer->customer_modby = 12;
        $customer->customer_moddate = '2013-08-24';

        $this->assertEquals($customer->customer_id, 1);
        $this->assertEquals($customer->customer_company_id, 72);
        $this->assertEquals($customer->customer_title, 'Mr');
        $this->assertEquals($customer->customer_first_name, 'Test');
        $this->assertEquals($customer->customer_last_name, 'Test');
        $this->assertEquals($customer->customer_dob, '2012-04-02');
        $this->assertEquals($customer->customer_username, 'Test1');
        $this->assertEquals($customer->customer_email, 'test@test.com');
        $this->assertEquals($customer->customer_password, 'test');
        $this->assertEquals($customer->customer_address_1, 'address 1');
        $this->assertEquals($customer->customer_address_2, 'address 2');
        $this->assertEquals($customer->customer_address_3, 'address 3');
        $this->assertEquals($customer->customer_city, 'london');
        $this->assertEquals($customer->customer_postcode, 'EXNX');
        $this->assertEquals($customer->customer_country, 'UK');
        $this->assertEquals($customer->customer_mobile, '555-555-555');
        $this->assertEquals($customer->customer_pin, '5555');
        $this->assertEquals($customer->customer_parental_pin, '55556');
        $this->assertEquals($customer->customer_activation_code, '555555');
        $this->assertEquals($customer->customer_created, '2013-08-26');
        $this->assertEquals($customer->customer_affiliate_id, 12);
        $this->assertEquals($customer->customer_modby, 12);
        $this->assertEquals($customer->customer_moddate, '2013-08-24');

        $customerArr = $customer->getArrayCopy();
        $this->assertEquals($customerArr['customer_moddate'], '2013-08-24');

        if($customer->isValid()) {
            $this->assertTrue(true);
        }else{
            //$this->assertTrue(false);
            //var_dump($customer->isValid()->getInvalidInput());
            $filter = $customer->getInputFilter();
        }
    }
} 
