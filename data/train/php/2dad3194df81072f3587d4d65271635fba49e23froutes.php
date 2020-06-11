<?php
/*
 * Routes for CUrlManager
 */
return array(
/*    // REST patterns
    array('api/list', 'pattern'=>'api/<model:\w+>', 'verb'=>'GET'),
    array('api/view', 'pattern'=>'api/<model:\w+>/<id:\d+>', 'verb'=>'GET'),
    array('api/update', 'pattern'=>'api/<model:\w+>/<id:\d+>', 'verb'=>'PUT'),
    array('api/delete', 'pattern'=>'api/<model:\w+>/<id:\d+>', 'verb'=>'DELETE'),
    array('api/create', 'pattern'=>'api/<model:\w+>', 'verb'=>'POST'),*/
    '<controller:\w+>/<action:\w+>' => '<controller>/<action>',
);