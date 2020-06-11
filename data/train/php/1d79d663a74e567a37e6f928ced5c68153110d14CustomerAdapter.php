<?php

require_once('CustomerInterface.php');

class CustomerAdapter implements ICustomer
{

    /**
     * @var Customer
     */
    protected $customer;

    /**
     * @param Customer $customer
     */
    public function __construct(Customer $customer)
    {
        $this->setCustomer($customer);
    }

    /**
     * @param Customer $customer
     */
    private function setCustomer($customer)
    {
        $this->customer = $customer;
    }

    public function getEmail()
    {
        return $this->customer->email;
    }

    public function getCreatedAt()
    {
        return $this->customer->createdAt;
    }
}