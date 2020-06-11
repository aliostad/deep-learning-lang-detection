<?php
	
$api = app('Dingo\Api\Routing\Router');

$api->version('v1', function ($api) {

	$api->post('auth/login', 'App\Api\V1\Controllers\AuthController@login');
	// $api->post('auth/signup', 'App\Api\V1\Controllers\AuthController@signup');
	$api->post('auth/recovery', 'App\Api\V1\Controllers\AuthController@recovery');
	$api->post('auth/reset', 'App\Api\V1\Controllers\AuthController@reset');

	$api->group(['middleware' => 'api.auth'], function ($api) {
		$api->get('user', 'App\Api\V1\Controllers\UserController@index');
		$api->post('user/store', 'App\Api\V1\Controllers\UserController@store');
		$api->delete('user/destroy/{id}', 'App\Api\V1\Controllers\UserController@destroy');

		$api->get('availability', 'App\Api\V1\Controllers\AvailabilityController@index');
		$api->post('availability/store', 'App\Api\V1\Controllers\AvailabilityController@store');
		$api->get('availability/show/{id}', 'App\Api\V1\Controllers\AvailabilityController@show');
		$api->put('availability/update/{id}', 'App\Api\V1\Controllers\AvailabilityController@update');
		$api->delete('availability/destroy/{id}', 'App\Api\V1\Controllers\AvailabilityController@destroy');

		$api->get('schedule', 'App\Api\V1\Controllers\ScheduleController@index');
		$api->post('schedule/store', 'App\Api\V1\Controllers\ScheduleController@store');
		$api->get('schedule/show/{id}', 'App\Api\V1\Controllers\ScheduleController@show');
		$api->put('schedule/update/{id}', 'App\Api\V1\Controllers\ScheduleController@update');
		$api->delete('schedule/destroy/{id}', 'App\Api\V1\Controllers\ScheduleController@destroy');
	});


	// example of protected route
	$api->get('protected', ['middleware' => ['api.auth'], function () {		
		return \App\User::all();
    }]);

	// example of free route
	$api->get('free', function() {
		return \App\User::all();
	});

});
