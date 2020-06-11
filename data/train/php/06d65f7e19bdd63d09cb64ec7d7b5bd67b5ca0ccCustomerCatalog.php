<?php
/**
 * Created by PhpStorm.
 * User: julia
 * Date: 2015-10-25
 * Time: 08:30
 */

namespace model;


class CustomerCatalog
{
    private $customerRepository;

    public function __construct(){
        $this->customerRepository = new \model\dal\CustomerRepository();
    }

    public function getCustomerBySsn($ssn){
        return $this->customerRepository->getCustomerBySsn($ssn);
    }

    public function getCustomerById($id){
        return $this->customerRepository->getCustomerById($id);
    }

    public function saveNewCustomerInRepository(CustomerModel $customer){
        $this->customerRepository->save($customer);
    }
}