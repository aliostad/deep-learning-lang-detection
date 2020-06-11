<?php
mb_internal_encoding("UTF-8");
$api_dev_key = '75fb5f5d562e10b07b46c541f6ac662a';
$api_paste_code = getenv('POPCLIP_TEXT'); 
// $api_paste_code = "testowy paste ze skryptu 4";
$skladnia = getenv('POPCLIP_OPTION_SYNTAX');
$waznosc = getenv('POPCLIP_OPTION_WAZNOSC');
$api_prywatnosc = '0'; 
$api_paste_name = 'Pasted using PopClip extension';
$api_expire_date = $waznosc;
$api_user_key = '';
$api_paste_name = urlencode($api_paste_name);
$api_paste_code = urlencode($api_paste_code);
$api_paste_format = $skladnia;
$url = 'http://pastebin.com/api/api_post.php';
$ch = curl_init($url);

curl_setopt($ch, CURLOPT_POST, true);
curl_setopt($ch, CURLOPT_POSTFIELDS, 'api_option=paste&api_user_key='.$api_user_key.'&api_paste_private='.$api_prywatnosc.'&api_paste_name='.$api_paste_name.'&api_paste_expire_date='.$api_expire_date.'&api_paste_format='.$api_paste_format.'&api_dev_key='.$api_dev_key.'&api_paste_code='.$api_paste_code.'');
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_VERBOSE, 1);
curl_setopt($ch, CURLOPT_NOBODY, 0);

$response  			= curl_exec($ch);
echo $response;
?>   

