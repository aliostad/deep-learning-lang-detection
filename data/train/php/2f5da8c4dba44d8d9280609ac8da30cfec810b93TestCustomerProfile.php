<?php

namespace Moolah;

class TestCustomerProfile implements CustomerProfile
{
    private $customer_id;

    private $customer_profile_id;

    public function __construct($customer_id, $customer_profile_id = null)
    {
        $this->customer_id         = $customer_id;
        $this->customer_profile_id = $customer_profile_id;
    }

    public function getCustomerId()
    {
        return $this->customer_id;
    }

    public function getCustomerProfileId()
    {
        return $this->customer_profile_id;
    }

    public function setCustomerProfileId($customer_profile_id)
    {
        $this->customer_profile_id = $customer_profile_id;
    }
}