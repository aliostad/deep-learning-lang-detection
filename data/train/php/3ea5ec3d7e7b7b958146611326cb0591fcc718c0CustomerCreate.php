<?php
namespace Fandepay\Api\Endpoints;

use Fandepay\Api\Model\Customer;

class CustomerCreate extends EndpointBase
{
    protected $customer;

    public function __construct(Customer $customer)
    {
        $this->customer = $customer;

        parent::__construct();
    }

    public function getCustomer()
    {
        return $this->customer;
    }

    public function setCustomer(Customer $customer)
    {
        $this->customer = $customer;

        return $this;
    }

    protected function getData()
    {
        return array(
            'customer' => $this->customer->toArray()
        );
    }

    protected function parseResult(array $result)
    {
        $result['customer'] = isset($result['customer']) ? new Customer($result['customer']) : null;

        return $result;
    }
}
