<?php

/**
 * Created by PhpStorm.
 * User: agustin
 * Date: 27/07/2015
 * Time: 15:01
 */
class CustomerReference
{
    public $customerId;
    public $customerEmail;
    public $customerPhones;

    /**
     * @return mixed
     */
    public function getCustomerPhones()
    {
        return $this->customerPhones;
    }

    /**
     * @param mixed $customerPhones
     */
    public function setCustomerPhones($customerPhones)
    {
        $this->customerPhones = $customerPhones;
    }

    /**
     * @return mixed
     */
    public function getCustomerId()
    {
        return $this->customerId;
    }

    /**
     * @param mixed $customerId
     */
    public function setCustomerId($customerId)
    {
        $this->customerId = $customerId;
    }

    /**
     * @return mixed
     */
    public function getCustomerEmail()
    {
        return $this->customerEmail;
    }

    /**
     * @param mixed $customerEmail
     */
    public function setCustomerEmail($customerEmail)
    {
        $this->customerEmail = $customerEmail;
    }

    public static function fromArray($data){
        if(!is_null($data)) {
            $customer = new CustomerReference();
            foreach ($data as $key => $value) {
                if ($key == "customerPhones") {
                    $customer->{$key} = CustomerPhones::fromArray($value);
                }
            }
            return $customer;
        }
    }
}