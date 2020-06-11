<?php
/**
 * Description of customer
 *
 * @author Ishrat
 */
class Customer 
{
    private $customer_name;
    private $customer_email;
    private $customer_account;
    
    /**
     * 
     * @return Account
     */
    public function get_customer_name() {
        return $this->customer_name;
    }

    public function get_customer_email() {
        return $this->customer_email;
    }

    public function get_customer_account() {
        return $this->customer_account;
    }

    public function set_customer_name($customer_name) {
        $this->customer_name = $customer_name;
    }

    public function set_customer_email($customer_email) {
        $this->customer_email = $customer_email;
    }

    public function set_customer_account($customer_account) {
        $this->customer_account = $customer_account;
    }



}
