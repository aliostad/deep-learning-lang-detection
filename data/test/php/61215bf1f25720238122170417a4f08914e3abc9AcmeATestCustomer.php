<?php

namespace Mobile\SymmetryBundle\Model;

/*
 * TEST CLASS SIMULATING A CUSTOMER 
 */
class AcmeATestCustomer
{
    
    private $id;
    private $customer_name;
    private $customer_code;
    private $customer_delivery_address;
    private $customer_contact_name;
    private $created_at;


    public function getId()
    {
        return $this->id;
    }

    public function setCustomerName($customerName)
    {
        $this->customer_name = $customerName;
    }

    public function getCustomerName()
    {
        return $this->customer_name;
    }

    public function setCustomerCode($customerCode)
    {
        $this->customer_code = $customerCode;
    }

    public function getCustomerCode()
    {
        return $this->customer_code;
    }

    public function setCustomerDeliveryAddress($customerDeliveryAddress)
    {
        $this->customer_delivery_address = $customerDeliveryAddress;
    }

    public function getCustomerDeliveryAddress()
    {
        return $this->customer_delivery_address;
    }

    public function setCustomerContactName($customerContactName)
    {
        $this->customer_contact_name = $customerContactName;
    }

    public function getCustomerContactName()
    {
        return $this->customer_contact_name;
    }

    public function setCreatedAt($createdAt)
    {
        $this->created_at = $createdAt;
    }

    public function getCreatedAt()
    {
        return $this->created_at;
    }
}