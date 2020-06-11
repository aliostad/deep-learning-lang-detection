<?
// $Id: index.php,v 1.2 2004/01/02 19:27:13 mmr Exp $
require(b1n_PATH_LIB . '/historic.lib.php');

$data['show_move']  = false;
$data['show_asknpc']= true;
$data['show_bank']  = true;
$data['show_login'] = true;
$data['show_drink'] = true;

// Checking actions 
switch($data['action'])
{
case 'prefs':
  b1n_getVar('show_move',   $data['show_move'],   $data['show_move']);
  b1n_getVar('show_login',  $data['show_login'],  $data['show_login']);
  b1n_getVar('show_asknpc', $data['show_asknpc'], $data['show_asknpc']);
  b1n_getVar('show_bank',   $data['show_bank'],   $data['show_bank']);
  b1n_getVar('show_drink',  $data['show_drink'],  $data['show_drink']);
  break;
}

$historic = b1n_historicGet($data);
?>
<table>
  <tr>
    <td>
<? require($data['page'] . '/' . $data['page'] . '.php'); ?>
    </td>
  </tr>
</table>
