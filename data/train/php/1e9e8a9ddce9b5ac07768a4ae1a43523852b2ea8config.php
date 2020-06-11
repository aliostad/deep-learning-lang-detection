<?php

$modelAuth = array(
    'model' => 'AdminUser',
    'fields' => array('username', 'password')
);
Configure::write('modelAuth', $modelAuth);
Configure::write('session_id', 'admin');

Configure::write('configs', array('configs-index'));
Configure::write('charts', array('users-index', 'statisticals-index'));
define('URL_API','http://wrappersrv.soci.vn/ads/api/');

$appbootsAPI = array(
    'API_01' => URL_API.'campaign.php?distributor_channel_id=9&act=publish',
    'API_02' => URL_API.'campaign.php?distributor_channel_id=9&ctype=1',
    'API_03' => URL_API.'campaign.php',
    'API_06' => URL_API.'campaign.php?act=script',
    'API_08' => URL_API.'app.php',
    'API_09' => URL_API.'app.php',
    'API_13' => URL_API.'app.php',
    'API_22' => URL_API.'app.php',
    'API_23' => URL_API.'app.php',
    'API_27' => URL_API.'campaign.php',
    'campaign' => URL_API.'campaign.php',
);
Configure::write('appbootsAPI', $appbootsAPI);

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
?>
