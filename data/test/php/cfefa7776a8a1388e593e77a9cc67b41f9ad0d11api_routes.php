<?php

/** API ROUTES */
$route['api/user/all']                      = 'api/api_user_controller/index';

/*$route['api/user/all'] = function(){
  return Api_user_controller::test();
};*/


$route['api/user/show/(:num)']              = 'api/api_user_controller/show/$1';
$route['api/user/store']['POST']            = 'api/api_user_controller/store';
$route['api/user/update/(:num)']['UPDATE']  = 'api/api_user_controller/update/$1';
$route['api/user/destroy/(:num)']['DELETE'] = 'api/api_user_controller/destroy/$1';