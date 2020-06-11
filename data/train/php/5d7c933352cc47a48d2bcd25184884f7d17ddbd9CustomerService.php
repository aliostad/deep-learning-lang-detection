<?php

class CustomerService {
    private $customerDao;
    
    public function __construct(){
        $this->customerDao = new CustomerDao();
    }
    
    public function getCustomerById($customerId){
        $customer = $this->customerDao->getCustomerById($customerId);
        return $customer;
    }
    
    public function getCustomerByEmail($email){
        $customer = $this->customerDao->getCustomerByEmail($email);
        return $customer;
    }
    
    public function getCustomerByNameAndPhone($fname, $lname, $phone){
        $customer = $this->customerDao->getCustomerByNameAndPhone($fname, $lname, $phone);
        return $customer;
    }
    
    public function getCustomers(){
        $customers = $this->customerDao->getAllCustomersFromDb();
        return $customers;
    }
    
    public function saveCustomer($customer){
        $this->customerDao->saveNewCustomerToDb($customer);
    }
    
    public function deleteCustomer($customerId){
        return $this->customerDao->deleteCustomerFromDb($customerId);
    }
    
    public function customerHasOrders($customerId){
        $orderService = new OrderService();
        $customerOrders = $orderService->getOrdersByCustomerId($customerId);
        if (count($customerOrders) > 0) {
            return true;
        } else {
            return false;
        }
    }
}

?>
