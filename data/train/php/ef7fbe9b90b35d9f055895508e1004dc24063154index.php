<?php
/**
 * 大师1.0版本前端APP接口。
 * @since 1.0.0
 */
define('API_PATH' , './');
define('API_BASE' , API_PATH . 'base/');
define('API_MODULE' , API_PATH . 'module/');

require_once dirname( dirname( dirname( __FILE__ ) ) ) . '/wp-load.php';

spl_autoload_register(function ($class) {
	$filename = API_BASE . $class . '.php';
	if(file_exists($filename))
		include $filename;
	else 
		include API_MODULE . $class . '.php';
});

AppApi::setDataFormat(AppApi::FORMAT_JSON);
$api = new AppApi(API_MODULE);
$api->run();