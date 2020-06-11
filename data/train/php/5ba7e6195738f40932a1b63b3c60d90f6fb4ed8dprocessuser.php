<?php
include('checklogin.php');
require_once('connection/weblynx.php');
require_once('includes/DB.php');


// Setup the database connection
$db = new DB();
$db->connect($database, $hostname, $username, $password);

function clean($val) {
    return mysql_real_escape_string($val);
}

$save['user_id'] = (int)$_POST['user_id'];

$save['username']    = $_POST['username'];
$updatePassword = '';
if(!empty($_POST['password'])) {
    $updatePassword = "password = '" . md5($_POST['password']) . "',";
}
$save['firstname']   = $_POST['firstname'];
$save['lastname']    = $_POST['surname'];
$save['email']       = $_POST['email'];
$save['user_active'] = $_POST['active'];

if(isset($save['user_id'])) {
    $user_id = (int) $save['user_id'];
    unset($save['user_id']);
}

if($user_id) {
    $sqlCmd = 'UPDATE';
    $where  = sprintf('WHERE user_id = %d', $user_id);
} else {
    $sqlCmd = 'INSERT';
    $where  = '';
}

$sql = sprintf("%s cms_users SET username = '%s', %s firstname = '%s', lastname = '%s', email = '%s', user_active = '%s' %s", $sqlCmd, clean($save['username']), $updatePassword, clean($save['firstname']), clean($save['lastname']), clean($save['email']), $save['user_active'], $where);

if($db->query($sql)) {
    header('Location: /admin/users.php');
    exit;
}
?>