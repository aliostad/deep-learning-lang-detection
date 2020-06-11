<?php
require_once(dirname(dirname(dirname(__FILE__))) . '/lib/routes.php');

var_dump(route('/'));
var_dump(route('/test'));
var_dump(route('/a/b/c'));
var_dump(route('/([^/]+?)', array('controller')));
var_dump(route('/([^/]+?)/([^/]+?)/(\d+)', array('controller', 'method', 'id')));
var_dump(route('/([^/]+?)/([^/]+?)', array('controller')));
var_dump(route('/([^/]+?)/([^/]+?)', array('controller', 'method')));
var_dump(route('/([^/]+?)/([^/]+?)', array('controller', 'method', 'id')));
var_dump(route('/a/([^/]+?)', array('method')));
var_dump(route('/([^/]+?)/a/(\d*?)', array('controller', 'id')));
var_dump(route('/a/(\d{1,6}).html$', array('id')));

$p = route('/mvc/(\d+)') and include('../mvc/hello' . $p[0] . '.php');
$p = route('/([^/]+?)') and include('../' . $p[0] . '/index.php');
