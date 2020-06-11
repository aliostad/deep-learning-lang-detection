<?php

/**
 * Implements hook_views_data().
 */
function sentiment_analyzer_views_data() {

  $data = array();

  $data['sentiment_analyzer']['table']['group'] = t('Sentiment Analyzer');

  $data['sentiment_analyzer']['table']['base'] = array(
    'title' => t('Sentiment Analyzer'),
    'help' => t('Contains Sentiment Analyzer data.'),
  );

  $data['sentiment_analyzer']['aid'] = array(
    'title' => t('AID'),
    'help' => t('The Analyzer ID.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['type'] = array(
    'title' => t('Type'),
    'help' => t('The record type.'),
    'field' => array(
      'handler' => 'views_handler_field',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_string',
    ),
  );

  $data['sentiment_analyzer']['date'] = array(
    'title' => t('Date'),
    'help' => t('The date it was recorded.'),
    'field' => array(
      'handler' => 'views_handler_field_date',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort_date',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_date',
    ),
  );

  $data['sentiment_analyzer']['elated'] = array(
    'title' => t('Elated'),
    'help' => t('The elated data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['depressed'] = array(
    'title' => t('Depressed'),
    'help' => t('The depressed data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['confused'] = array(
    'title' => t('Confused'),
    'help' => t('The confused data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['clearheaded'] = array(
    'title' => t('Clearheaded'),
    'help' => t('The clearheaded data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['anxious'] = array(
    'title' => t('Anxious'),
    'help' => t('The anxious data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['composed'] = array(
    'title' => t('Composed'),
    'help' => t('The composed data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['tired'] = array(
    'title' => t('Tired'),
    'help' => t('The tired data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['energetic'] = array(
    'title' => t('Energetic'),
    'help' => t('The energetic data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['hostile'] = array(
    'title' => t('Hostile'),
    'help' => t('The hostile data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );

  $data['sentiment_analyzer']['agreeable'] = array(
    'title' => t('Agreeable'),
    'help' => t('The agreeable data.'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
  );
  return $data;
}
