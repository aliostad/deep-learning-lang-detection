<?php


class Customer {

    private $customer_name;
    private $email_address;
    private $customer_account;
    
    public function set_customer_name($customer_name) {
        $this->customer_name = $customer_name;
    }

    public function set_email_address($email_address) {
        $this->email_address = $email_address;
    }

    public function set_customer_account($customer_account) {
        $this->customer_account = $customer_account;
    }

    public function get_customer_name() {
        return $this->customer_name;
    }

    public function get_email_address() {
        return $this->email_address;
    }

        
    
   
    /**
     * 
     * @return Account
     */
    public function get_customer_account() {
        return $this->customer_account;
    }


    
}
