<?php
/**
 * @file
 * vista_map.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function vista_map_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "openlayers" && $api == "openlayers_maps") {
    return array("version" => "1");
  }
  if ($module == "page_manager" && $api == "pages_default") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_views_api().
 */
function vista_map_views_api($module = NULL, $api = NULL) {
  return array("api" => "3.0");
}
