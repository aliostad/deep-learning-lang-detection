<?php
namespace controller;

use model\Model_Customer;
use system\Controller;

class Controller_Customer extends Controller{
        public $customer_id;
       
        public function __construct(){
            preg_match("/\/id\/(.*)$/simU",$_SERVER['REQUEST_URI'],$id);
            $this->customer_id=$id[1];
            $customer=new Model_Customer;
            $customer_info=$customer->getCustomerInfo($this->customer_id);
            $customer->close();
            $this->render("customer/index",['customer_info'=>$customer_info]);
        }
          
}
