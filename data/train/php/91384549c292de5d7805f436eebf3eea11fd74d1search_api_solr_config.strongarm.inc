<?php
/**
 * @file
 * search_api_solr_config.strongarm.inc
 */

/**
 * Implements hook_strongarm().
 */
function search_api_solr_config_strongarm() {
  $export = array();

  $strongarm = new stdClass();
  $strongarm->disabled = FALSE; /* Edit this to true to make a default strongarm disabled initially */
  $strongarm->api_version = 1;
  $strongarm->name = 'search_api_facets_search_ids';
  $strongarm->value = array(
    'internal_search_index_nodes' => array(
      'search_api_views:dossier_object_stories_add_existing_search_api:page_add_object_story' => 'search_api_views:dossier_object_stories_add_existing_search_api:page_add_object_story',
      'search_api_views:dossier_references_add_existing_search_api:page_add_reference' => 'search_api_views:dossier_references_add_existing_search_api:page_add_reference',
      'search_api_views:dossier_events_add_existing_search_api:page_add_event' => 'search_api_views:dossier_events_add_existing_search_api:page_add_event',
      'search_api_views:object_story_events_add_existing_search_api:page_add_event' => 'search_api_views:object_story_events_add_existing_search_api:page_add_event',
      'search_api_views:object_story_references_add_existing_search_api:page_add_reference' => 'search_api_views:object_story_references_add_existing_search_api:page_add_reference',
      'search_api_views:object_story_objects_add_existing_search_api:page_add_object' => 'search_api_views:object_story_objects_add_existing_search_api:page_add_object',
      'search_api_views:object_story_events_add_existing_search_api:default' => 'search_api_views:object_story_events_add_existing_search_api:default',
      'search_api_views:dossier_events_search_api_:default' => 'search_api_views:dossier_events_search_api_:default',
      'search_api_views:dossier_events_search_api_:page_add_event' => 'search_api_views:dossier_events_search_api_:page_add_event',
      'search_api_views:dossier_events_search_api_:events_listing' => 'search_api_views:dossier_events_search_api_:events_listing',
      'search_api_views:events_search_api_:default' => 'search_api_views:events_search_api_:default',
      'search_api_views:events_search_api_:events_listing' => 'search_api_views:events_search_api_:events_listing',
      'search_api_views:object_stories_search_api_:default' => 'search_api_views:object_stories_search_api_:default',
      'search_api_views:object_stories_search_api_:page_add_object_story' => 'search_api_views:object_stories_search_api_:page_add_object_story',
      'search_api_views:object_stories_search_api_:object_story_listing' => 'search_api_views:object_stories_search_api_:object_story_listing',
      'search_api_views:objects_search_api:default' => 'search_api_views:objects_search_api:default',
      'search_api_views:objects_search_api:page_add_object' => 'search_api_views:objects_search_api:page_add_object',
      'search_api_views:objects_search_api:object_listing' => 'search_api_views:objects_search_api:object_listing',
      'search_api_views:dossier_events_add_existing_search_api:default' => 'search_api_views:dossier_events_add_existing_search_api:default',
      'search_api_views:dossier_events_timeline_search_api_:default' => 'search_api_views:dossier_events_timeline_search_api_:default',
      'search_api_views:dossier_events_timeline_search_api_:page' => 'search_api_views:dossier_events_timeline_search_api_:page',
      'search_api_views:dossier_events_timeline_search_api:default' => 'search_api_views:dossier_events_timeline_search_api:default',
      'search_api_views:dossier_events_timeline_search_api:page_add_event' => 'search_api_views:dossier_events_timeline_search_api:page_add_event',
      'search_api_views:dossier_events_timeline_search_api:page_timeline' => 'search_api_views:dossier_events_timeline_search_api:page_timeline',
      'search_api_views:dossier_events_timeline_search_api:page_1' => 'search_api_views:dossier_events_timeline_search_api:page_1',
      'search_api_views:dossier_events_timeline_search_api:timeline_data_page' => 'search_api_views:dossier_events_timeline_search_api:timeline_data_page',
      'search_api_views:dossier_events_search_api:default' => 'search_api_views:dossier_events_search_api:default',
      'search_api_views:dossier_events_search_api:page_1' => 'search_api_views:dossier_events_search_api:page_1',
      'search_api_views:dossier_events_search_api:timeline_data_page' => 'search_api_views:dossier_events_search_api:timeline_data_page',
      'search_api_views:dossier_events_search_api:dossier_events_page' => 'search_api_views:dossier_events_search_api:dossier_events_page',
      'search_api_views:dossier_events_search_api:panel_pane_1' => 'search_api_views:dossier_events_search_api:panel_pane_1',
      'search_api_views:dossier_events_search_api:dossier_events_pane' => 'search_api_views:dossier_events_search_api:dossier_events_pane',
      'search_api_views:object_story_events_add_existing_search_api:page_1' => 'search_api_views:object_story_events_add_existing_search_api:page_1',
      'search_api_views:object_story_events_add_existing_search_api:page_add_event_dossier_context' => 'search_api_views:object_story_events_add_existing_search_api:page_add_event_dossier_context',
      'search_api_views:object_story_references_add_existing_search_api:page_1' => 'search_api_views:object_story_references_add_existing_search_api:page_1',
      'search_api_views:object_story_objects_add_existing_search_api:page_1' => 'search_api_views:object_story_objects_add_existing_search_api:page_1',
      'search_api_views:object_story_objects_add_existing_search_api:page_add_object_dossier_context' => 'search_api_views:object_story_objects_add_existing_search_api:page_add_object_dossier_context',
      'search_api_views:object_story_references_add_existing_search_api:page_add_reference_dossier_context' => 'search_api_views:object_story_references_add_existing_search_api:page_add_reference_dossier_context',
      'search_api_views:dossier_object_stories_add_existing_search_api:page_1' => 'search_api_views:dossier_object_stories_add_existing_search_api:page_1',
      'search_api_views:dossier_object_stories_add_existing_search_api:internal' => 'search_api_views:dossier_object_stories_add_existing_search_api:internal',
      'search_api_views:dossier_events_add_existing_search_api:page_1' => 'search_api_views:dossier_events_add_existing_search_api:page_1',
      'search_api_views:dossier_events_add_existing_search_api:page_add_event_search_internal' => 'search_api_views:dossier_events_add_existing_search_api:page_add_event_search_internal',
      'search_api_views:dossier_object_stories_add_existing_search_api:page_add_object_story_internal' => 'search_api_views:dossier_object_stories_add_existing_search_api:page_add_object_story_internal',
      'search_api_views:object_story_objects_add_existing_search_api:page_add_object_dossier_context_internal' => 'search_api_views:object_story_objects_add_existing_search_api:page_add_object_dossier_context_internal',
      'search_api_views:object_story_events_add_existing_search_api:page_add_event_dossier_context_internal' => 'search_api_views:object_story_events_add_existing_search_api:page_add_event_dossier_context_internal',
      'search_api_views:object_story_references_add_existing_search_api:page_add_reference_dossier_context_internal' => 'search_api_views:object_story_references_add_existing_search_api:page_add_reference_dossier_context_internal',
      'search_api_views:dossier_events_add_existing_search_api:internal_search_events_timeline_page' => 'search_api_views:dossier_events_add_existing_search_api:internal_search_events_timeline_page',
      'search_api_views:dossier_events_search_api:dossier_events_pane_timeline' => 'search_api_views:dossier_events_search_api:dossier_events_pane_timeline',
      'search_api_views:object_story_events_add_existing_search_api:page_timline' => 'search_api_views:object_story_events_add_existing_search_api:page_timline',
      'search_api_views:object_story_events_add_existing_search_api:page_timeline' => 'search_api_views:object_story_events_add_existing_search_api:page_timeline',
      'search_api_views:dossier_references_add_existing_search_api:page_add_reference_internal' => 'search_api_views:dossier_references_add_existing_search_api:page_add_reference_internal',
      'search_api_views:dossier_events_search_api:openlayers_dossier_events' => 'search_api_views:dossier_events_search_api:openlayers_dossier_events',
      'search_api_views:dossier_objects_add_existing_search_api:default' => 'search_api_views:dossier_objects_add_existing_search_api:default',
      'search_api_views:dossier_objects_add_existing_search_api:page_add_object_story' => 'search_api_views:dossier_objects_add_existing_search_api:page_add_object_story',
      'search_api_views:dossier_objects_add_existing_search_api:page_add_object_story_internal' => 'search_api_views:dossier_objects_add_existing_search_api:page_add_object_story_internal',
      'search_api_views:dossier_objects_add_existing_search_api:page_add_object_internal' => 'search_api_views:dossier_objects_add_existing_search_api:page_add_object_internal',
      'search_api_views:dossier_objects_add_existing_search_api:page_add_object' => 'search_api_views:dossier_objects_add_existing_search_api:page_add_object',
    ),
  );
  $export['search_api_facets_search_ids'] = $strongarm;

  return $export;
}
