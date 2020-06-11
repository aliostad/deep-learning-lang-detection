<?php
// +----------------------------------------------------------------------
// | Fanwe 方维o2o商业系统
// +----------------------------------------------------------------------
// | Copyright (c) 2011 http://www.fanwe.com All rights reserved.
// +----------------------------------------------------------------------
// | Author: 云淡风轻(97139915@qq.com)
// +----------------------------------------------------------------------


//用于处理 api同步登录的回调

define("FILE_PATH","/callback/api_login"); //文件目录
require_once '../../system/system_init.php';
require_once APP_ROOT_PATH.'app/Lib/'.APP_TYPE.'/core/main_init.php';

$api_class = "Qqv2";
if(file_exists(APP_ROOT_PATH.'system/api_login/'.$api_class.'_api.php'))
{
	$api = $GLOBALS['db']->getRow("select * from ".DB_PREFIX."api_login where class_name='".$api_class."'");
	require_once APP_ROOT_PATH.'system/api_login/'.$api_class.'_api.php';
	$api_class = $api['class_name']."_api";
	$api_obj = new $api_class($api);
	$api_obj->callback();
}

?>