<?php
/**
 * 配置游戏的HTTP接口和Socket接口的文件
 * Created on 2011-12-23
 * @author zhangyoucheng
 * 
 */
$GAME_HTTP_API = array(
	"sendyuanbao" => array("api_path" => "/api/admin.php"),
	"alluseroffline" => array("api_path" => "/api/admin.php"),
	"sendmail" => array("api_path" => "/api/admin.php"),
	"getonlinecount" => array("api_path" => "/api/admin.php"),
	"chatbanuser" => array("api_path" => "/api/admin.php"),
    "useroffline" => array("api_path" => "/api/admin.php"),
    "getonlinecount" => array("api_path" => "/api/admin.php"),
    "banaccountname" => array("api_path" => "/api/admin.php"),
    "banuserip" => array("api_path" => "/api/admin.php"),
	"getunfinishtask" => array("api_path" => "/api/admin.php"),
	"finishtask" => array("api_path" => "/api/admin.php"),
	"getuserstatus" => array("api_path" => "/api/admin.php"),
	"getuserdata" => array("api_path" => "/api/admin.php"),
	"modifyuserdata" => array("api_path" => "/api/admin.php"),
	"getonlinelist" => array("api_path" => "/api/admin.php"),
	"applygoods" => array("api_path" => "/api/admin.php"),
	"getuserbasestatus" => array("api_path" => "/api/admin.php"),
	"getuserpet" => array("api_path" => "/api/admin.php"),
	"getfcm" => array("api_path" => "/api/admin.php"),
	"setfcm" => array("api_path" => "/api/admin.php"),
	"setmaxnum" => array("api_path" => "/api/admin.php"),
	"getmaxnum" => array("api_path" => "/api/admin.php"),
	"broadcast" => array("api_path" => "/api/admin.php"),
	"configbroadcast" => array("api_path" => "/api/admin.php"),
	"getguildmessage" => array("api_path" => "/api/admin.php"),
	"getmagicboxstatus" => array("api_path" => "/api/admin.php"),
	"setmagicboxstatus" => array("api_path" => "/api/admin.php"),
	"getloginnotice" => array("api_path" => "/api/admin.php"),
	"setloginnotice" => array("api_path" => "/api/admin.php"),
	"getcheapshop" => array("api_path" => "/api/admin.php"),
	"setcheapshop" => array("api_path" => "/api/admin.php"),
	"getwuhunbag" => array("api_path" => "/api/admin.php"),
	"getmagicbox" => array("api_path" => "/api/admin.php"),
	"setactivity" => array("api_path" => "/api/admin.php"),
	"createrole" => array("api_path" => "/api/admin.php"),
	"setguidtitle" => array("api_path" => "/api/admin.php"),
	"seticon" => array("api_path" => "/api/admin.php"),
        "getbossindex" => array("api_path" => "/api/admin.php"),
        "getbossinfo" => array("api_path" => "/api/admin.php"),
        "getallbodyids" => array("api_path" => "/api/admin.php"),
        "deletebossinfo" => array("api_path" => "/api/admin.php"),
        "getallmonsterid" => array("api_path" => "/api/admin.php"),
        "createbossindex" => array("api_path" => "/api/admin.php"),
        "setbossinfo" => array("api_path" => "/api/admin.php"),
        "setbossstate" => array("api_path" => "/api/admin.php"),
        "getmapinfo" => array("api_path" => "/api/admin.php"),
        "copybossinfo" => array("api_path" => "/api/admin.php"),
        "setgameopenday" => array("api_path" => "/api/admin.php"),
        "getallloginfo" => array("api_path" => "/api/admin.php"),
        "add_festival" => array("api_path" => "/api/admin.php"),
        "del_festival" => array("api_path" => "/api/admin.php"),
);

$GAME_SOCKET_API = array(
	"sendyuanbao" => array("api_method" => ""),
	"alluseroffline" => array("api_method" => "", "api_id" => ""),
	"sendmail" => array("api_method" => ""),
	"getonlinecount" => array("api_method" => ""),
	"chatbanuser" => array("api_method" => ""),
    "useroffline" => array("api_method" => ""),
    "getonlinecount" => array("api_method" => ""),
);
