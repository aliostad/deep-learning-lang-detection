<?php

require_once 'init.php';

$l = $API->getval('l');

if ($l) {
    $API->LANG->setlang($l);
    $API->TPL->assign('message', $API->LANG->_('Language was set. We are redirecting you in 2 seconds.'));
    if (!$returnto) $returnto = '/';
    $API->safe_redirect($returnto,2);
    $API->TPL->display('message.tpl');
    die();
}

$API->TPL->assign('headeradd', '<link rel="stylesheet" type="text/css" href="./css/countries.css"> ');

$API->TPL->assign('navclass', 'apple');
$API->TPL->assign('pagetitle', $API->LANG->_('Choose your country or region'));
$API->TPL->assign('footername', $API->LANG->_('Set language'));
$API->TPL->display('setlang.tpl');
?>