<?php

class cutomer {

    static function insertNewCustomer($customer_info) {
        $sql="INSERT INTO `rehanna_customer`(`customer_name`, `customer_phone`, `customer_job`, `customer_age`,`customer_gender`,`customer_job_period`, `customer_favorites_category`, `customer_favorites_type`, `customer_favorites_concentration`) VALUES "
                . "('".$customer_info["fullname"]."','".$customer_info["Phone_Num"]."','".$customer_info["job_type"]."','".$customer_info["age"]."','".$customer_info["gender"]."','".$customer_info["job_period"]."','".$customer_info["choose_category"]."','".$customer_info["choose_type"]."','".$customer_info["concentration"]."')";
        db::getInstance()->query($sql);
    }
    
    static function selectCustomerPhone($phone) {
        $sql="SELECT * FROM `rehanna_customer` WHERE `customer_phone`=".$phone. " limit 1";
        return db::getInstance()->fetch_row($sql);
    }
}

