<?php

namespace Vespolina\CustomerBundle\Tests;

use Symfony\Bundle\FrameworkBundle\Test\WebTestCase;

use Vespolina\CustomerBundle\Document\CustomerAddress;


class CustomerCreateTest extends WebTestCase
{
    protected $client;

    public function setUp()
    {
        $this->client = $this->createClient();
    }

    public function getKernel(array $options = array())
    {
        if (!self::$kernel) {
            self::$kernel = $this->createKernel($options);
            self::$kernel->boot();
        }

        return self::$kernel;
    }

    /**
     * @covers Vespolina\CustomerBundle\Model\CustomerManager::createCustomer
     */
    public function testCustomerCreate()
    {

        $customerManager = $this->getKernel()->getContainer()->get('vespolina_customer.customer_manager');


        $customer = $customerManager->createCustomer();

        $customer->setName('Enron');
        $customer->setCustomerId('ABC0001');
        $customerAddress = new CustomerAddress();
        $customerAddress->setStreet('Sesamstreet 11');
        $customerAddress->setCity('Mumbai');
        $customerAddress->setState('Somewhere');
        $customerAddress->setCountry('in');

        $customer->addAddress($customerAddress);

        $customerManager->updateCustomer($customer);

        
    }
}