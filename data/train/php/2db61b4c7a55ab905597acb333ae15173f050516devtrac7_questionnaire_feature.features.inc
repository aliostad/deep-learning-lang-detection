<?php
/**
 * @file
 * devtrac7_questionnaire_feature.features.inc
 */

/**
 * Implements hook_ctools_plugin_api().
 */
function devtrac7_questionnaire_feature_ctools_plugin_api($module = NULL, $api = NULL) {
  if ($module == "context" && $api == "context") {
    return array("version" => "3");
  }
  if ($module == "quicktabs" && $api == "quicktabs") {
    return array("version" => "1");
  }
  if ($module == "strongarm" && $api == "strongarm") {
    return array("version" => "1");
  }
}

/**
 * Implements hook_views_api().
 */
function devtrac7_questionnaire_feature_views_api($module = NULL, $api = NULL) {
  return array("api" => "3.0");
}
