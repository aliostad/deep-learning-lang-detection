<?php
/**
 * Created by PhpStorm.
 * User: prakash
 * Date: 3/22/17
 * Time: 8:46 PM
 */

namespace App\Portal\Services;


use App\Portal\Repositories\CustomerRepository;

class CustomerService
{

    /**
     * @var CustomerRepository
     */
    private $customerRepository;

    public function __construct(CustomerRepository $customerRepository)
    {
        $this->customerRepository = $customerRepository;
    }

    public function getcustomer()
    {
        return $this->customerRepository->getCustomer();
    }

    public function getCustomerId($id)
    {
        return $this->customerRepository->getCustomerId($id);
    }


    public function changePassword( $request,$id)
    {
        $data = $this->customerRepository->ChangePassword($request,$id);
        return $data;
    }
}