<?php

namespace App\Repositories;

use App\Interfaces\Factories\CustomerFactoryInterface;
use App\Interfaces\Repositories\CustomerBalanceRepositoryInterface;
use App\Models\Customer;
use App\Models\CustomerBalance;

/**
 * Class CustomerBalanceRepository
 * @package App\Repositories
 */
class CustomerBalanceRepository implements CustomerBalanceRepositoryInterface
{
    /** @var CustomerFactoryInterface $customerFactory */
    protected $customerFactory;

    /**
     * CustomerBalanceRepository constructor.
     * @param CustomerFactoryInterface $customerFactory
     */
    public function __construct(
        CustomerFactoryInterface $customerFactory
    )
    {
        $this->customerFactory = $customerFactory;
    }

    /**
     * @param Customer $customer
     * @param array $parameters
     * @return CustomerBalance
     */
    public function create(Customer $customer, array $parameters = []) : CustomerBalance
    {
        $customerBalance = $this->customerFactory->newCustomerBalance();
        $customerBalance->fill($parameters);
        $customerBalance->customer()->associate($customer);
        $customerBalance->save();
        return $customerBalance;
    }
}
