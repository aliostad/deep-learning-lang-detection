<?php

namespace Bws\Repository;

use Bws\Entity\InvoiceAddress;
use Bws\Entity\Customer;
use Bws\Entity\CustomerStub;

class CustomerRepositoryMock implements CustomerRepository
{
    private $customers = array();
    private $lastInserted;
    private $matchedInvoice;

    public function __construct()
    {
        $this->save(new CustomerStub());
    }

    public function truncate()
    {
        $this->customers = array();
    }

    /**
     * @return Customer
     */
    public function factory()
    {
        return new CustomerStub();
    }

    public function save(Customer $customer)
    {
        $this->customers[] = $customer;
        $this->lastInserted = $customer;
    }

    /**
     * @return Customer
     */
    public function findLastInserted()
    {
        return $this->lastInserted;
    }

    /**
     * @param InvoiceAddress $invoiceAddress
     *
     * @return Customer|null
     */
    public function match(InvoiceAddress $invoiceAddress)
    {
        /** @var Customer $customer */
        foreach ($this->customers as $customer) {
            if ($customer->getCustomerString() == $invoiceAddress->getCustomerString()) {
                $this->matchedInvoice = $invoiceAddress;
                return $customer;
            }
        }

        return null;
    }

    /**
     * @return InvoiceAddress
     */
    public function getMatchedInvoice()
    {
        return $this->matchedInvoice;
    }

    /**
     * @param $customerId
     *
     * @return Customer|null
     */
    public function find($customerId)
    {
        /** @var Customer $customer */
        foreach ($this->customers as $customer) {
            if ($customer->getId() == $customerId) {
                return $customer;
            }
        }

        return null;
    }
}
 