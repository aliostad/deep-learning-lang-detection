 <?php
/**
 * @file
 * Views data from IP geolocation module
 */

function ip_geoloc_views_data() {
  $data = array();
  $data['ip_geoloc']['table']['group']  = t('IP geolocations');

  $data['ip_geoloc']['table']['base'] = array(
    'field' => 'ip_address',
    'title' => t('IP geolocations'),
    'help' => t('Stores IP geolocation information.'),
  );

  $data['ip_geoloc']['table']['join'] = array(
    // ip_geoloc.ip_address connects to accesslog.hostname
    'accesslog' => array(
      'left_field' => 'hostname',
      'field' => 'ip_address',
      'type' => 'INNER'
    ),
  );

  $data['ip_geoloc']['ip_address'] = array(
    'title' => t('IP address'),
    'help' => t('IP address'),
    'field' => array(
      'handler' => 'views_handler_field',
      'click sortable' => TRUE,
    ),
   'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
      'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    )
  );
/*
  $data['ip_geoloc']['id'] = array(
    'title' => t('ID'),
    'help' => t('db'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
      'click sortable' => TRUE,
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
  );
 */
  $data['ip_geoloc']['latitude'] = array(
    'title' => t('Latitude'),
    'help' => t('Latitude'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
      'click sortable' => TRUE,
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['longitude'] = array(
    'title' => t('Longitude'),
    'help' => t('Longitude'),
    'field' => array(
      'handler' => 'views_handler_field_numeric',
      'click sortable' => TRUE,
    ),
    'filter' => array(
      'handler' => 'views_handler_filter_numeric',
    ),
    'sort' => array(
      'handler' => 'views_handler_sort',
    ),
  );

  $data['ip_geoloc']['formatted_address'] = array(
    'title' => t('Address'),
    'help' => t('Address formatted as a string'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['country'] = array(
    'title' => t('Country'),
    'help' => t('Country'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['country_code'] = array(
    'title' => t('Country code'),
    'help' => t('Country code'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['region'] = array(
    'title' => t('Region'),
    'help' => t('Region'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['region_code'] = array(
    'title' => t('Region code'),
    'help' => t('Region code'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['city'] = array(
    'title' => t('City'),
    'help' => t('City'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['postal_code'] = array(
    'title' => t('Postal code'),
    'help' => t('Post code or ZIP'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['locality'] = array(
    'title' => t('Suburb'),
    'help' => t('Locality (e.g. suburb)'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['route'] = array(
    'title' => t('Street'),
    'help' => t('Route (street)'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['street_number'] = array(
    'title' => t('Street no.'),
    'help' => t('Street number'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  $data['ip_geoloc']['administrative_area_level_1'] = array(
    'title' => t('State'),
    'help' => t('administrative area level 1 (state or province)'),
    'field' => array(
     'handler' => 'views_handler_field',
     'click sortable' => TRUE,
    ),
    'filter' => array(
     'handler' => 'views_handler_filter_string',
    ),
    'argument' => array(
     'handler' => 'views_handler_argument_string',
    ),
    'sort' => array(
     'handler' => 'views_handler_sort',
    )
  );

  return $data;
}
