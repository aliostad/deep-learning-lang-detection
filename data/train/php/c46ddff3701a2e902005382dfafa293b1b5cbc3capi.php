<?php
include "autoload.php";

$memc = new Memcache;
$memc->connect('127.0.0.1', 11211);

function get_api($api_id) {
    global $memc;
    return $memc->get($api_id);
}

function set_api($api_id, $api_config) {
    global $memc;
    $memc->set($api_id, $api_config);
}

Flox_Api::$loader = function($api_id){
    global $memc;
    return $memc->get($api_id);

};
Flox_Api::$saver = function($api_id, $api_config){
    global $memc;
    $memc->set($api_id, $api_config);
};

$api_config = array(
    'title' => 'HTTP请求',
    'in' => array(
        array(
            'name' => 'url',
        ),
    ),
    'out' => array(
        array(
            'name' => 'content',
        ),
    ),
    'expr' => 'return file_get_contents($url);',
);
$api = Flox_Api::instance('http_get');
//if(! $ret = $api->load($api_config, $err)) {
//    echo "load err:". $err;
//    die;
//}

//var_dump("config", $api->config());
//$api->save();

$ret = $api->execute(array('url' => 'http://baidu.com/'));
var_dump("execute", $ret);
/*
$api = Flox_Api::instance('http_get');

$ret = $api->in(array(
        'name' => 'url',
        'type' => 'string',
        'title' => 'URL地址',
    ))
    ->out(array(
        'name' => 'content',
        'path' => '',
        'title' => '内容',
    )) 
    ->expr('return file_get_contents($url);')
    ->execute(array(
        'url' => 'http://www.baidu.com/',
    ));

 */

