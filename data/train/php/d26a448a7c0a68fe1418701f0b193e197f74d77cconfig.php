<?php

namespace app\config;
use api;

$api_include = './api/api.php';
$base_path = 'api\base_path';
$autoload = 'api\autoload';
$factory = 'api\factory';
$api = 'api\api';
$app = 'api\app';
$router_main = 'api\router_main';
$request = 'api\request';
$loader = 'api\loader';
//$main_router = 'api\main_router';
api\template_path::$template_path = dirname(__file__).'/';
$app_sub_folder = "/";
$db = 'api\db\db';

class page_routes {
    public $index = "app\page\index\controllers\config";
}

class app_routes {
    public $admin = "app\apps\admin\app";
}


class db_config {
    public $production = array('mysql:host=127.0.0.1;dbname=DDD', 'root', 'DDD', array('prefix'=>'api_', \PDO::MYSQL_ATTR_READ_DEFAULT_FILE => '/etc/my.cnf', \PDO::ATTR_PERSISTENT => true));
}

