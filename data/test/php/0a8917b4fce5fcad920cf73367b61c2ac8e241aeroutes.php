<?php
return array(
	'_root_'  => 'checkin/public/add',  // The default route
	'_404_'   => 'welcome/404',    // The main 404 route

	'hello(/:name)?' => array('welcome/hello', 'name' => 'hello'),

	/**** PUBLIC ROUTING ****/

	/**** API ROUTING *****/
	'api/users'               => 'user/api/users',
	'api/users/here'          => 'user/api/here',
	'api/users/here/(:id)'    => 'user/api/here/$1',
	'api/user/(:id)/checkins' => 'checkin/api/user_checkins/$1',
	'api/user/(:id)/skills'   => 'user/api/user_skills/$1',
	'api/user/(:id)'          => 'user/api/user/$1',
	'api/seats'               => 'user/api/seats',

	'api/checkins'            => 'checkin/api/checkins',
	'api/checkins/(asc|desc)' => 'checkin/api/checkins/$1',

	'api/checkins/user/(:id)' => 'checkin/api/user/$1',
	'api/checkins/user/(:id)/(asc|desc)' => 'checkin/api/user/$1/$2',
	'api/checkin/(:id)'       => 'checkin/api/checkin/$1',
	'api/coworking/next_events' => 'calendar/api/next_events',

	'api/reasons'             => 'checkin/api/reasons',

	'api/company/(:id)'        => 'user/api/company/$1',
	'api/companies'            => 'user/api/companies',



	'api/(:segment)/(:any)'        => '$1/api/$2',

	/**** ADMIN ROUTING ****/
	'admin'                   => 'checkin/admin',
	'admin/settings'          => 'settings',
	'admin/settings/plugin/(:any)'  => 'settings/plugin/$1',
	'admin/(:segment)'        => '$1/admin',
	'admin/(:segment)/(:any)' => '$1/admin/$2',

	'coworker/(:id)'          => 'user/profile/view/$1',


);
