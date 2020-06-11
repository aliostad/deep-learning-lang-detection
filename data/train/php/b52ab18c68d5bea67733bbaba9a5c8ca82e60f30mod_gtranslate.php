<?php
/**
* @version   $Id: mod_gtranslate.php 167 2012-10-26 19:28:57Z edo888 $
* @package   GTranslate
* @copyright Copyright (C) 2008-2011 Edvard Ananyan. All rights reserved.
* @license   GNU/GPL v3 http://www.gnu.org/licenses/gpl.html
*/

defined('_JEXEC') or die('Restricted access');

require_once (dirname(__FILE__).'/helper.php');

$params = modGTranslateHelper::getParams($params);

$method = $params->get('method');
$load_jquery = $params->get('load_jquery');
$look = $params->get('look');
$flag_size = $params->get('flag_size');
$orientation = $params->get('orientation');
$pro_version = $params->get('pro_version');
$enterprise_version = $params->get('enterprise_version');
$new_tab = $params->get('new_tab');
$analytics = $params->get('analytics');
$language = $params->get('language');
$show_en = $params->get('show_en');
$show_ar = $params->get('show_ar');
$show_bg = $params->get('show_bg');
$show_zhCN = $params->get('show_zh-CN');
$show_zhTW = $params->get('show_zh-TW');
$show_hr = $params->get('show_hr');
$show_cs = $params->get('show_cs');
$show_da = $params->get('show_da');
$show_nl = $params->get('show_nl');
$show_fi = $params->get('show_fi');
$show_fr = $params->get('show_fr');
$show_de = $params->get('show_de');
$show_el = $params->get('show_el');
$show_hi = $params->get('show_hi');
$show_it = $params->get('show_it');
$show_ja = $params->get('show_ja');
$show_ko = $params->get('show_ko');
$show_no = $params->get('show_no');
$show_pl = $params->get('show_pl');
$show_pt = $params->get('show_pt');
$show_ro = $params->get('show_ro');
$show_ru = $params->get('show_ru');
$show_es = $params->get('show_es');
$show_sv = $params->get('show_sv');
$show_ca = $params->get('show_ca');
$show_tl = $params->get('show_tl');
$show_iw = $params->get('show_iw');
$show_id = $params->get('show_id');
$show_lv = $params->get('show_lv');
$show_lt = $params->get('show_lt');
$show_sr = $params->get('show_sr');
$show_sk = $params->get('show_sk');
$show_sl = $params->get('show_sl');
$show_uk = $params->get('show_uk');
$show_vi = $params->get('show_vi');
$show_sq = $params->get('show_sq');
$show_et = $params->get('show_et');
$show_gl = $params->get('show_gl');
$show_hu = $params->get('show_hu');
$show_mt = $params->get('show_mt');
$show_th = $params->get('show_th');
$show_tr = $params->get('show_tr');
$show_fa = $params->get('show_fa');
$show_af = $params->get('show_af');
$show_ms = $params->get('show_ms');
$show_sw = $params->get('show_sw');
$show_ga = $params->get('show_ga');
$show_cy = $params->get('show_cy');
$show_be = $params->get('show_be');
$show_is = $params->get('show_is');
$show_mk = $params->get('show_mk');
$show_yi = $params->get('show_yi');
$show_hy = $params->get('show_hy');
$show_az = $params->get('show_az');
$show_eu = $params->get('show_eu');
$show_ka = $params->get('show_ka');
$show_ht = $params->get('show_ht');
$show_ur = $params->get('show_ur');
$main_url = $_SERVER['HTTP_HOST'];

if($_SERVER['SERVER_PORT'] != '80')
    $main_url = substr($main_url, 0, strpos($main_url, ':'));

require(JModuleHelper::getLayoutPath('mod_gtranslate'));