<?php

require_once 'config.php';

if (isset($_POST['init'])) {
    if ($_POST['init'] == 'FacadeType') {
        $out = Config::$facadeType;
        echo json_encode($out);
    }
    if ($_POST['init'] == 'Filling') {
        $out = Config::$filling;
        echo json_encode($out);
    }
}

if (isset($_POST['facadeType'])) {
    if ($_POST['facadeType'] == '') {
        $out = Config::$facadeType0;
        echo json_encode($out);
    }
    if ($_POST['facadeType'] == '1') {
        $out = Config::$facadeType1;
        echo json_encode($out);
    }
    if ($_POST['facadeType'] == '2') {
        $out = Config::$facadeType2;
        echo json_encode($out);
    }
    if ($_POST['facadeType'] == '3') {
        $out = Config::$facadeType3;
        echo json_encode($out);
    }
    if ($_POST['facadeType'] == '4') {
        $out = Config::$facadeType4;
        echo json_encode($out);
    }
}




