<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of customer
 *
 * @author LAB
 */
class Customer {
    
    Private $customer_name;
    private $customer_email_address;
    private $customer_account;
    
    public function get_customer_name() {
        return $this->customer_name;
    }

    public function get_customer_email_address() {
        return $this->customer_email_address;
    }

    public function get_customer_account() {
        return $this->customer_account;
    }

    public function set_customer_name($customer_name) {
        $this->customer_name = $customer_name;
    }

    public function set_customer_email_address($customer_email_address) {
        $this->customer_email_address = $customer_email_address;
    }

    public function set_customer_account($customer_account) {
        $this->customer_account = $customer_account;
    }


}
