<?php

namespace Tasks;

function editApiKey ($mysqli, $api_key_id, $api_key_name) {

    $api_key_name = $mysqli->real_escape_string($api_key_name);

    $sql = "update tasks set insert_api_key_name = '$api_key_name'"
        ." where insert_api_key_id = $api_key_id";
    include_once __DIR__.'/../mysqli_query_exit.php';
    mysqli_query_exit($mysqli, $sql);

    $sql = "update tasks set update_api_key_name = '$api_key_name'"
        ." where update_api_key_id = $api_key_id";
    mysqli_query_exit($mysqli, $sql);

}
