<?php
// +----------------------------------------------------------------------
// | Fanweo2o商业系统 最新版V3.03.3285  。
// +----------------------------------------------------------------------
// | 购买本程序，请联系旺旺名：zengchengshu
// +----------------------------------------------------------------------
// | 淘宝购买地址：http://cnlichuan.taobao.com
// +----------------------------------------------------------------------


//用于处理 api同步登录的回调

define("FILE_PATH",""); //文件目录，空为根目录
require_once './system/system_init.php';
require_once APP_ROOT_PATH.'app/Lib/'.APP_TYPE.'/core/main_init.php';

$api_class = strim($_REQUEST['c']);
if(file_exists(APP_ROOT_PATH.'system/api_login/'.$api_class.'_api.php'))
{
	$api = $GLOBALS['db']->getRow("select * from ".DB_PREFIX."api_login where class_name='".$api_class."'");
	require_once APP_ROOT_PATH.'system/api_login/'.$api_class.'_api.php';
	$api_class = $api['class_name']."_api";
	$api_obj = new $api_class($api);
	$api_obj->callback();
}

?>