<?php

$route['api']                                         = 'api'; //Defines the default controller

$route['api']                                         = 'api';
$route['api/(:any)']                                  = 'api/$1';
$route['api/(:any)/(:any)']                           = 'api/$1/$2';
$route['api/(:any)/(:any)/(:any)']                    = 'api/$1/$2/$3';
$route['api/(:any)/(:any)/(:any)/(:any)']             = 'api/$1/$2/$3/$4';
$route['api/(:any)/(:any)/(:any)/(:any)/(:any)']      = 'api/$1/$2/$3/$4/$5';
