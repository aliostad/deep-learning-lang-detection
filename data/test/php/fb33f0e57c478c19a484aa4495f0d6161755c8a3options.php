<?php
// ClanSphere 2010 - www.clansphere.net
// $Id: $

$cs_lang = cs_translate('news');

if(isset($_POST['submit'])) {

  $save = array();
  $save['host']        = $_POST['host'];
  $save['dns']         = $_POST['dns'];
  $save['query_port']  = (int) $_POST['query_port'];
  $save['client_port'] = (int) $_POST['client_port'];
  $save['ttl']         = (int) $_POST['ttl'];

  require_once 'mods/clansphere/func_options.php';
  
  cs_optionsave('tinyts3', $save);
  
  cs_redirect($cs_lang['success'], 'options', 'roots');
}

$data = array();
$data['options'] = cs_sql_option(__FILE__,'tinyts3');

echo cs_subtemplate(__FILE__,$data,'tinyts3','options');