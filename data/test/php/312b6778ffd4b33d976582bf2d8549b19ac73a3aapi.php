<?php

$router->add(
    '/api',
    [
        'module'     => 'api',
        'namespace'  => 'Netex\Api\Controllers\\',
        'controller' => 'index',
        'action'     => 'index'
    ]
);

$router->add(
    '/api/:controller/:action',
    [
        'module'     => 'api',
        'namespace'  => 'Netex\Api\Controllers\\',
        'controller' => 1,
        'action'     => 2,
    ]
);
$router->add(
    '/api/:controller',
    [
        'module'     => 'api',
        'namespace'  => 'Netex\Api\Controllers\\',
        'controller' => 1,
        'action'     => 'index',
    ]
);
$router->add(
    '/api/:controller/:action',
    [
        'module'     => 'api',
        'namespace'  => 'Netex\Api\Controllers\\',
        'controller' => 1,
        'action'     => 2,
    ]
);
$router->add(
    '/api/:controller/:action/:params',
    [
        'module'     => 'api',
        'namespace'  => 'Netex\Api\Controllers\\',
        'controller' => 1,
        'action'     => 2,
        'params'     => 3
    ]
);