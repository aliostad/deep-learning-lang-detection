<?php
/**
 * webEdition CMS
 *
 * This source is part of webEdition CMS. webEdition CMS is
 * free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 3 of the License, or
 * any later version.
 *
 * The GNU General Public License can be found at
 * http://www.gnu.org/copyleft/gpl.html.
 * A copy is found in the textfile
 * webEdition/licenses/webEditionCMS/License.txt
 *
 * @category   webEdition
 * @package    webEdition_javamenu
 * @copyright  Copyright (c) 2008 living-e AG (http://www.living-e.com)
 * @license    http://www.gnu.org/copyleft/gpl.html  GPL
 */


if (defined("CUSTOMER_TABLE")) {
	include_once($_SERVER["DOCUMENT_ROOT"]."/webEdition/we/include/we_language/".$GLOBALS["WE_LANGUAGE"]."/modules/customer.inc.php");
}

$we_menu_customer["000100"]["text"] =$l_customer["menu_customer"];
$we_menu_customer["000100"]["parent"] = "000000";
$we_menu_customer["000100"]["perm"] = "";
$we_menu_customer["000100"]["enabled"] = "1";

$we_menu_customer["000200"]["text"] = $l_customer["menu_new"];
$we_menu_customer["000200"]["parent"] = "000100";
$we_menu_customer["000200"]["cmd"] = "new_customer";
$we_menu_customer["000200"]["perm"] = "NEW_CUSTOMER || ADMINISTRATOR";
$we_menu_customer["000200"]["enabled"] = "1";

$we_menu_customer["000400"]["text"] = $l_customer["menu_save"];
$we_menu_customer["000400"]["parent"] = "000100";
$we_menu_customer["000400"]["cmd"] = "save_customer";
$we_menu_customer["000400"]["perm"] = "EDIT_CUSTOMER || NEW_CUSTOMER || ADMINISTRATOR";
$we_menu_customer["000400"]["enabled"] = "1";

$we_menu_customer["000600"]["text"] = $l_customer["menu_delete"];
$we_menu_customer["000600"]["parent"] = "000100";
$we_menu_customer["000600"]["cmd"] = "delete_customer";
$we_menu_customer["000600"]["perm"] = "DELETE_CUSTOMER || ADMINISTRATOR";
$we_menu_customer["000600"]["enabled"] = "1";

$we_menu_customer["000700"]["parent"] = "000100"; // separator

$we_menu_customer["000800"]["text"]=$l_customer["menu_admin"];
$we_menu_customer["000800"]["parent"] = "000100";    
$we_menu_customer["000800"]["enabled"]  = "0";       

$we_menu_customer["000810"]["text"] = $l_customer["field_admin"]."...";
$we_menu_customer["000810"]["parent"] = "000800";
$we_menu_customer["000810"]["cmd"] = "show_admin";
$we_menu_customer["000810"]["perm"] = "SHOW_CUSTOMER_ADMIN || ADMINISTRATOR";
$we_menu_customer["000810"]["enabled"] = "1";

$we_menu_customer["000820"]["text"] = $l_customer["sort_admin"]."...";
$we_menu_customer["000820"]["parent"] = "000800";
$we_menu_customer["000820"]["cmd"] = "show_sort_admin";
$we_menu_customer["000820"]["perm"] = "SHOW_CUSTOMER_ADMIN || ADMINISTRATOR";
$we_menu_customer["000820"]["enabled"] = "1";

$we_menu_customer["000850"]["parent"] = "000100"; // separator

$we_menu_customer["000860"]["text"] = $l_customer["import"]."...";
$we_menu_customer["000860"]["parent"] = "000100";
$we_menu_customer["000860"]["cmd"] = "import_customer";
$we_menu_customer["000860"]["perm"] = "SHOW_CUSTOMER_ADMIN || ADMINISTRATOR";
$we_menu_customer["000860"]["enabled"] = "1";

$we_menu_customer["000870"]["text"] = $l_customer["export"]."...";
$we_menu_customer["000870"]["parent"] = "000100";
$we_menu_customer["000870"]["cmd"] = "export_customer";
$we_menu_customer["000870"]["perm"] = "SHOW_CUSTOMER_ADMIN || ADMINISTRATOR";
$we_menu_customer["000870"]["enabled"] = "1";

$we_menu_customer["000900"]["parent"] = "000100"; // separator


$we_menu_customer["000910"]["text"] = $l_customer["search"]."...";
$we_menu_customer["000910"]["parent"] = "000100";
$we_menu_customer["000910"]["cmd"] = "show_search";
$we_menu_customer["000910"]["perm"] = "";
$we_menu_customer["000910"]["enabled"] = "1";


$we_menu_customer["000920"]["text"] = $l_customer["settings"]."...";
$we_menu_customer["000920"]["parent"] = "000100";
$we_menu_customer["000920"]["cmd"] = "show_customer_settings";
$we_menu_customer["000920"]["perm"] = "";
$we_menu_customer["000920"]["enabled"] = "1";

$we_menu_customer["000950"]["parent"] = "000100"; // separator

$we_menu_customer["001000"]["text"] = $l_customer["menu_exit"];
$we_menu_customer["001000"]["parent"] = "000100";
$we_menu_customer["001000"]["cmd"] = "exit_customer";
$we_menu_customer["001000"]["perm"] = "";
$we_menu_customer["001000"]["enabled"] = "1";

$we_menu_customer["001100"]["text"] = $l_customer["menu_help"];
$we_menu_customer["001100"]["parent"] = "000000";
$we_menu_customer["001100"]["perm"] = "";
$we_menu_customer["001100"]["enabled"] = "1";

$we_menu_customer["001200"]["text"] = $l_customer["menu_help"]."...";;
$we_menu_customer["001200"]["parent"] = "001100";
$we_menu_customer["001200"]["cmd"] = "help_modules";
$we_menu_customer["001200"]["perm"] = "";
$we_menu_customer["001200"]["enabled"] = "1";

$we_menu_customer["001300"]["text"] = $l_customer["menu_info"]."...";;
$we_menu_customer["001300"]["parent"] = "001100";
$we_menu_customer["001300"]["cmd"] = "info_modules";
$we_menu_customer["001300"]["perm"] = "";
$we_menu_customer["001300"]["enabled"] = "1";

?>
