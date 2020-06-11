<?php

function sess_start() {
    $GLOBALS['_SESS'] = [];

    $mySessName = ini_get('session.name');

    if (!isset($_COOKIE[$mySessName])) {

        $mySessessID = uniqid('mySess_', true);

        setcookie($mySessName, $mySessessID);

        $GLOBALS['filename'] = $mySessessID;

    } else {

        $GLOBALS['filename'] = $_COOKIE[$mySessName];

        $mySessSavePath = ini_get('session.save_path');

        $saveFile = $mySessSavePath . '/' . $GLOBALS['filename'];

        $data = file_get_contents($saveFile);

        $GLOBALS['_SESS'] = unserialize($data);

    }
}

function sess_write()
{
    $mySessSavePath = ini_get('session.save_path');

    $saveFile = $mySessSavePath . '/' . $GLOBALS['filename'];

    $data = serialize($GLOBALS["_SESS"]);

    file_put_contents($saveFile, $data);
}

register_shutdown_function('sess_write');