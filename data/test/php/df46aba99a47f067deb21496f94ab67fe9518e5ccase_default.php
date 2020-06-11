<?php
/**
 * <DZCP-Extended Edition>
 * @package: DZCP-Extended Edition
 * @author: DZCP Developer Team || Hammermaps.de Developer Team
 * @link: http://www.dzcp.de || http://www.hammermaps.de
 */

if(_adminMenu != 'true') exit();

$show = show($dir."/profil", array("show_about" => show_profil_links('1'),
                                   "show_clan" => show_profil_links('2'),
                                   "show_contact" => show_profil_links('3'),
                                   "show_favos" => show_profil_links('4'),
                                   "show_hardware" => show_profil_links('5')));