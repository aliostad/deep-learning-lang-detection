<?php

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of CustomerDetailVO
 *
 * @author krisada.thiangtham
 */
class CustomerDetailVO {

    //put your code here
    private $customerId;
    private $customerName;
    private $custoemrAddress;
    private $customerTel;
    private $customerFax;

    public function getCustomerId() {
        return $this->customerId;
    }

    public function setCustomerId($customerId) {
        $this->customerId = $customerId;
    }

    public function getCustomerName() {
        return $this->customerName;
    }

    public function getCustoemrAddress() {
        return $this->custoemrAddress;
    }

    public function getCustomerTel() {
        return $this->customerTel;
    }

    public function getCustomerFax() {
        return $this->customerFax;
    }

    public function setCustomerName($customerName) {
        $this->customerName = $customerName;
    }

    public function setCustoemrAddress($custoemrAddress) {
        $this->custoemrAddress = $custoemrAddress;
    }

    public function setCustomerTel($customerTel) {
        $this->customerTel = $customerTel;
    }

    public function setCustomerFax($customerFax) {
        $this->customerFax = $customerFax;
    }

}
