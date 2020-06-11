<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
*/

/**
 * Description of CustomerManager
 *
 * @author ziyang
 */
class CustomerManager {
    //put your code here
    public function checkCustomerEmailExist($email) {
        $link = getConnection();
        $checkResult = false;
        $query = " select 	customer_id,
                        customer_email,
                        customer_password,
                        customer_archived
                from    tb_customer
                where   customer_archived =   'N'
                and     customer_email =       '".$email."'";



        $result = executeNonUpdateQuery($link , $query);
        closeConnection($link);

        $num_rows = mysql_num_rows($result); // Find no. of rows retrieved from DB

        if ( $num_rows == 1 ) {
            // email exists
            $checkResult = true;
        }
        return $checkResult;
    }

    public function checkCustomerReviewExist($customer_id, $product_id) {
        $link = getConnection();
        $checkResult = false;
        $query = "select 	review_id, customer_id, product_id, review_rate, review_text,
                        review_date
                from tb_review
                where customer_id = ".$customer_id."
                and product_id =    '".$product_id."'";



        $result = executeNonUpdateQuery($link , $query);
        closeConnection($link);

        $num_rows = mysql_num_rows($result); // Find no. of rows retrieved from DB

        if ( $num_rows == 1 ) {
            // email exists
            $checkResult = true;
        }
        return $checkResult;
    }

    public function customerLogin($email, $password) {
        // if result is 0 -> login fail
        $link = getConnection();
        $loginResult = 0;
        $password = md5($password);

        $query = " select 	customer_id,
                        customer_email,
                        customer_password,
                        customer_archived
                from    tb_customer
                where   customer_archived =   'N'
                and     customer_email =       '".$email."'
                and     customer_password =   '".$password."'";



        $result = executeNonUpdateQuery($link , $query);
        closeConnection($link);

        $num_rows = mysql_num_rows($result); // Find no. of rows retrieved from DB

        if ( $num_rows == 1 ) {
            // login successful
            while ($newArray = mysql_fetch_array($result)) {
                $loginResult = $newArray['customer_id'];
            }
        }else {
            $loginResult = 0; // login failure
        }
        return $loginResult;
    }

    public function getCustomerList() {
        $customerList = null;
        $count = 0;
        $link = getConnection();
        $query="select 	customer_id,
                        customer_password,
                        customer_email,
                        customer_firstname,
                        customer_lastname,
                        customer_telephone,
                        customer_mobile,
                        customer_newsletter,
                        customer_last_edit,
                        customer_last_visit,
                        customer_register_date,
                        customer_archived
                from 	tb_customer
                where   customer_archived =  'N'";

        $result = executeNonUpdateQuery($link , $query);
        closeConnection($link);

        while ($newArray = mysql_fetch_array($result)) {
            $customer = new Customer();
            $customer->set_customer_id($newArray['customer_id']);
            $customer->set_password($newArray['customer_password']);
            $customer->set_email($newArray['customer_email']);
            $customer->set_firstname($newArray['customer_firstname']);
            $customer->set_lastname($newArray['customer_lastname']);
            $customer->set_telephone($newArray['customer_telephone']);
            $customer->set_mobile($newArray['customer_mobile']);
            $customer->set_newsletter($newArray['customer_newsletter']);
            $customer->set_last_edit_time($newArray['customer_last_edit']);
            $customer->set_last_visit_time($newArray['customer_last_visit']);
            $customer->set_register_date($newArray['customer_register_date']);
            $customer->set_archived($newArray['customer_archived']);

            $customerList[$count] = $customer;
            $count++;
        }
        return $customerList;
    }

    public function getCustomerListRegisterForPeriod($back_no_of_days) {
        $customerList = null;
        $count = 0;
        $link = getConnection();
        $query="select 	customer_id,
                        customer_password,
                        customer_email,
                        customer_firstname,
                        customer_lastname,
                        customer_telephone,
                        customer_mobile,
                        customer_newsletter,
                        customer_last_edit,
                        customer_last_visit,
                        customer_register_date,
                        customer_archived
                from 	tb_customer
                where   customer_archived =  'N'
                and     customer_register_date > ADDDATE(now(),INTERVAL -".$back_no_of_days." DAY)";

        $result = executeNonUpdateQuery($link , $query);
        closeConnection($link);

        while ($newArray = mysql_fetch_array($result)) {
            $customer = new Customer();
            $customer->set_customer_id($newArray['customer_id']);
            $customer->set_password($newArray['customer_password']);
            $customer->set_email($newArray['customer_email']);
            $customer->set_firstname($newArray['customer_firstname']);
            $customer->set_lastname($newArray['customer_lastname']);
            $customer->set_telephone($newArray['customer_telephone']);
            $customer->set_mobile($newArray['customer_mobile']);
            $customer->set_newsletter($newArray['customer_newsletter']);
            $customer->set_last_edit_time($newArray['customer_last_edit']);
            $customer->set_last_visit_time($newArray['customer_last_visit']);
            $customer->set_register_date($newArray['customer_register_date']);
            $customer->set_archived($newArray['customer_archived']);

            $customerList[$count] = $customer;
            $count++;
        }
        return $customerList;
    }
}
?>
