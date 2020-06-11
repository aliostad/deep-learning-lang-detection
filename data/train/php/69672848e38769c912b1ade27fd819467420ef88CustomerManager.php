<?php

class CustomerManager implements ICustomerManager
{
    private $customerDao;

    private function validateCustomerNames($customer)
    {
        if (!isset($customer->email))
        {
            RestLogger::log('CustomerManager::validateCustomerNames email not defined');
            return;
        }

        if (!isset($customer->firstName))
        {
            $name = substr($customer->email, 0, strpos($customer->email, '@'));

            $names = explode(".", $name);

            if (count($names) == 1)
            {
                $names = explode("-", $name);
            }
            if (count($names) == 1)
            {
                $names = explode("_", $name);
            }

            $customer->firstName = $names[0];

            if (count($names) > 1)
            {
                $customer->lastName = $names[count($names) - 1];
            }
        }

    }

    function __construct($customerDao)
    {
        $this->customerDao = $customerDao;

        RestLogger::log("Customer manager created...");
    }

    public function validateCustomer($customer)
    {
        if ($customer->id <= 0)
        {
            $this->customerDao->loadCustomerByEmail($customer);
        }

        $this->validateCustomerNames($customer);
    }

    public function validateAndSaveCustomer($customer)
    {
        if ($customer->id <= 0)
        {
            if (!$this->customerDao->isCustomerExists($customer))
            {
                $this->customerDao->insertCustomer($customer);
            }
        }

        $this->validateCustomerNames($customer);
    }
}
