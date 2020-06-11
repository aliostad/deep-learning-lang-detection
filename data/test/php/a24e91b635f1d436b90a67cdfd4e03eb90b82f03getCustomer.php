<?php
    include("../../library/config.php");
    authenticate();
    
    if(isset($_GET["t"])){
        if(checkTransactionCustomer($_GET["t"]) == 1)
        {
            $customer = array("code" => getCustomerFromTransaction($_GET["t"]), "customer" => getCustomerNameByCode(getCustomerFromTransaction($_GET["t"])));
            echo json_encode($customer);
        }
        else{
            $customer = array("code" => "", "customer" => "Set Customer");
            echo json_encode($customer);
        }
    }
?>