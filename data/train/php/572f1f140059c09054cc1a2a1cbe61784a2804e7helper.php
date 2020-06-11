<?php
/**
* @version   $Id: helper.php 132 2012-02-15 19:44:06Z edo888 $
* @package   GTranslate
* @copyright Copyright (C) 2008-2011 Edvard Ananyan. All rights reserved.
* @license   GNU/GPL v3 http://www.gnu.org/licenses/gpl.html
*/

defined('_JEXEC') or die('Restricted access');

class modGTranslateHelper {
    function getParams(&$params) {
        $params->def('method', 'google_default');
        $params->def('load_jquery', 1);
        $params->def('look', 'both');
        $params->def('orientation', 'h');
        $params->def('flag_size', 16);
        $params->def('language', 'en');
        $params->def('pro_version', 0);
        $params->def('enterprise_version', 0);
        $params->def('new_tab', 0);
        $params->def('analytics', 0);
        $params->def('show_en', 2);
        $params->def('show_ar', 1);
        $params->def('show_bg', 1);
        $params->def('show_zh-CN', 1);
        $params->def('show_zh-TW', 1);
        $params->def('show_hr', 1);
        $params->def('show_cs', 1);
        $params->def('show_da', 1);
        $params->def('show_nl', 1);
        $params->def('show_fi', 1);
        $params->def('show_fr', 2);
        $params->def('show_de', 2);
        $params->def('show_el', 1);
        $params->def('show_hi', 1);
        $params->def('show_it', 2);
        $params->def('show_ja', 1);
        $params->def('show_ko', 1);
        $params->def('show_no', 1);
        $params->def('show_pl', 1);
        $params->def('show_pt', 2);
        $params->def('show_ro', 1);
        $params->def('show_ru', 2);
        $params->def('show_es', 2);
        $params->def('show_sv', 1);
        $params->def('show_ca', 1);
        $params->def('show_tl', 1);
        $params->def('show_iw', 1);
        $params->def('show_id', 1);
        $params->def('show_lv', 1);
        $params->def('show_lt', 1);
        $params->def('show_sr', 1);
        $params->def('show_sk', 1);
        $params->def('show_sl', 1);
        $params->def('show_uk', 1);
        $params->def('show_vi', 1);
        $params->def('show_sq', 1);
        $params->def('show_et', 1);
        $params->def('show_gl', 1);
        $params->def('show_hu', 1);
        $params->def('show_mt', 1);
        $params->def('show_th', 1);
        $params->def('show_tr', 1);
        $params->def('show_fa', 1);
        $params->def('show_af', 1);
        $params->def('show_ms', 1);
        $params->def('show_sw', 1);
        $params->def('show_ga', 1);
        $params->def('show_cy', 1);
        $params->def('show_be', 1);
        $params->def('show_is', 1);
        $params->def('show_mk', 1);
        $params->def('show_yi', 1);
        $params->def('show_hy', 1);
        $params->def('show_az', 1);
        $params->def('show_eu', 1);
        $params->def('show_ka', 1);
        $params->def('show_ht', 1);
        $params->def('show_ur', 1);
        return $params;
    }
}