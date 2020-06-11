<?php
function nextend_api_auth_flow() {
    $api_key = NextendRequest::getVar('api_key');
    $api_secret = NextendRequest::getVar('api_secret');
    if (session_id() == "") {
        @session_start();
    }
    if(!$api_key || !$api_secret){
        $api_key = isset($_SESSION['api_key']) ? $_SESSION['api_key'] : null;
        $api_secret = isset($_SESSION['api_secret']) ? $_SESSION['api_secret'] : null;
    }else{
        $_SESSION['api_key'] = $api_key;
        $_SESSION['api_secret'] = $api_secret;
    }

    if ($api_key && $api_secret) {
        require_once(dirname(__FILE__) . "/api/phpFlickr.php");

        $f = new phpFlickr($api_key, $api_secret);

        if (empty($_GET['frob'])) {
            $f->auth('read', false);
        } else {
            $result = $f->auth_getToken($_GET['frob']);
            unset($_SESSION['api_key']);
            unset($_SESSION['api_secret']);
            unset($_SESSION['phpFlickr_auth_token']);
            echo '<script type="text/javascript">';
            echo 'window.opener.setToken("'.$result['token'].'");';
            echo '</script>';
        }
    }
}