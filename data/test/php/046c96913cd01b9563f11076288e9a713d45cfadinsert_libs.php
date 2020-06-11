<?php
// +----------------------------------------------------------------------
// | Fanwe 方维o2o商业系统
// +----------------------------------------------------------------------
// | Copyright (c) 2011 http://www.fanwe.com All rights reserved.
// +----------------------------------------------------------------------
// | Author: 云淡风轻(97139915@qq.com)
// +----------------------------------------------------------------------

/*以下为动态载入的函数库*/
function insert_login_tip()
{
	$api_list = $GLOBALS['db']->getAllCached("select * from ".DB_PREFIX."api_login");
	$api_str = "";
	foreach ($api_list as $k=>$v)
	{
		require_once APP_ROOT_PATH."system/api_login/".$v['class_name']."_api.php";
		$class_name = $v['class_name']."_api";
		$o = new $class_name($v);
		$api_str.="".$o->get_api_url()."";
	}
	$GLOBALS['tmpl']->assign("api_login",$api_str);
	
	return $GLOBALS['tmpl']->fetch("inc/login_tip.html");
}

function insert_api_login()
{
	$api_list = $GLOBALS['db']->getAllCached("select * from ".DB_PREFIX."api_login");
	$api_str = "";
	foreach ($api_list as $k=>$v)
	{
		require_once APP_ROOT_PATH."system/api_login/".$v['class_name']."_api.php";
		$class_name = $v['class_name']."_api";
		$o = new $class_name($v);
		$api_str.=$o->get_big_api_url();
	}
	$GLOBALS['tmpl']->assign("api_login",$api_str);
	return $GLOBALS['tmpl']->fetch("inc/api_login.html");
}
?>