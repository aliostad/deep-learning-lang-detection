<?php

require_once('init.php');

$API->auth();


require_once 'classes/rmuapi.class.php';

$RMU = new RMU($API->account['api_client_id'], $API->account['api_password']);
if ($RMU->_fail) {
    $API->error('Unable to connect to RMU API');
}
if ($_SERVER['REQUEST_METHOD'] == "POST") {

    $mode = $API->getval('mode');

    if ($mode == 'personal') {
        $email = htmlspecialchars($API->getval('email'));
        if (!$API->validemail($email)) {
            $API->error('Invalid email address format');
        }
        $name = htmlspecialchars($API->getval('name'));
        $phone = htmlspecialchars($API->getval('phone'));
        $company = htmlspecialchars($API->getval('company'));

        if (!$email || !$name || !$phone || !$company) {
            $API->error('Missing form fields');
        }

        $to_db['name'] = $name;
        $to_db['email'] = $email;
        $to_db['phone'] = $phone;
        $to_db['company'] = $company;

        $API->DB->query("UPDATE accounts SET {$API->DB->build_update_query($to_db)} WHERE id={$API->account['id']}");

        if ($API->DB->mysql_errno() == 1062) {
            $API->error('Unable to update account information - email in use');
        }

        $API->safe_redirect($API->SEO->make_link('settings'), 2);
        $API->message('Contact information was successfully updated', 'Redirecting you back in 2 seconds');
    } elseif ($mode == 'api') {
        $api_data = $API->getval('api', 'array');

        if ($api_data['api_password']) {
            if ((string) $api_data['api_password'] != $API->getval('api_password2')) {
                $API->error('API passwords does not match');
            }
        }
        
        //die(var_dump($api_data));

        $response = $RMU->api_query(array('mode' => 'set_api_info', 'data' => $api_data));

        if ($response['error']) {
            $API->error('Failed to set API data, API responded with error: ' . $response['error']);
        }

        if ($api_data['api_password']) {
            $API->DB->query("UPDATE accounts SET api_password={$API->DB->sqlesc($api_data['api_password'])} WHERE id={$API->account['id']}");
        }
        $API->safe_redirect($API->SEO->make_link('settings'), 2);
        $API->message('API data was successfully set', 'Redirecting you back in 2 seconds');
    }
}

$API->TPL->assign('api_info', array_map('htmlspecialchars', $RMU->get_api_info()));
$API->TPL->display('settings.tpl');
?>