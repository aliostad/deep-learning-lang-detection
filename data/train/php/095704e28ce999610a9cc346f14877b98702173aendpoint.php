<?php

session_start();
error_reporting(0);

/**
 * Access point for all API calls
 */

define('ROOT', 'http://localhost/projects/api/');

set_include_path(
    '.' . PATH_SEPARATOR . 
    './library/MyApi' . PATH_SEPARATOR .
    './library/Api'
);
				
include("library/Api/Bootstrap.php");
include("library/MyApi/MyApi.php");

// Create request object
$request = new Api_Request(ROOT);
#$request->setParams(array("version", "service", "method"));
$request->setParams(array("version", "key", "service", "method"));
$request->analyze();

// Load config
$config = parse_ini_file("config.ini", true);

// Create Custom api instance
$api = new MyApi();

// Add modify config hook
$api->addHook("Api_Hook_ConfigModify", Api_Hook_IHook::HOOK_CONFIG_LOADED);
$api->addHook("Api_Hook_BlockIp", Api_Hook_IHook::HOOK_BEFORE_SERVICE_EXECUTE);
$api->addHook("Api_Hook_RequestLimit", Api_Hook_IHook::HOOK_BEFORE_SERVICE_EXECUTE);
$api->addHook("Api_Hook_ParserModify", Api_Hook_IHook::HOOK_MODIFY_PARSER);

// http://localhost/projects/api/v1/public/database.xml?username=admin&password=123
#$api->addHook("Api_Hook_Login", Api_Hook_IHook::HOOK_BEFORE_SERVICE_EXECUTE);

// http://localhost/projects/api/v1/public/database.xml
$api->addHook("MyApi_Hook_ApiKey", Api_Hook_IHook::HOOK_BEFORE_SERVICE_EXECUTE);
$api->addHook("MyApi_Hook_Database", Api_Hook_IHook::HOOK_BEFORE_SERVICE_EXECUTE);

// Handle api request and catch errors
try
{
    $api->handle($request, $config);
}
catch (Api_Error $error)
{
    $response = new Api_Response($error->getCode(), null, $error);
    $api->send($response);
}
