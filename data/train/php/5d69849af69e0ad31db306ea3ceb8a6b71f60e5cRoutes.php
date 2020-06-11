<?php
return array(
    // Adminland
    array('GET|POST|PUT|DELETE', 'admin/api/appointments/[i:params]?', 'admin/api/appointments',   'api_appointments'),
    array('GET',                 'admin/api/appointments/count',       'admin/api/appointments',   'api_appointment_count'),
    array('GET|PUT',             'admin/api/editor',                   'admin/api/editor',         'api_editor'),
    array('GET|POST|DELETE',     'admin/api/media/[i:params]?',        'admin/api/media',          'api_media'),
    array('GET|PUT',             'admin/api/configuration',            'admin/api/configuration',  'api_configuration')
);
?>