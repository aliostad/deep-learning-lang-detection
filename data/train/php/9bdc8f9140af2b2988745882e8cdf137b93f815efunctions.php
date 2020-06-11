<?php

function isPresent($Service_Id, $Service_Consume_by_Customer) {
    $Service_Price = -1;
    for ($index = 0; $index < count($Service_Consume_by_Customer); $index++) {
        $Single_Service = $Service_Consume_by_Customer[$index];
//        echo $Service_Id . " " . $Single_Service['Service_Id'];
        if ($Service_Id == $Single_Service['Service_Id']) {
            $Service_Price = $Single_Service['Service_Price'];
            return $Service_Price;
        }
    }
    return $Service_Price;
}

?>