<?php
$api = app('Dingo\Api\Routing\Router');

// Version 1 of our API
$api->version('v1', function ($api) {

	// Set our namespace for the underlying routes
	$api->group(['namespace' => 'Api\Controllers', 'middleware' => 'cors'], function ($api) {

		// Login route
		$api->post('login', 'AuthController@authenticate');
		$api->post('register', 'AuthController@register');

		// Dogs! All routes in here are protected and thus need a valid token
		//$api->group( [ 'protected' => true, 'middleware' => 'jwt.refresh' ], function ($api) {
		// $api->group( [ 'middleware' => 'jwt.refresh' ], function ($api) {

			$api->get('users/me', 'AuthController@me');
			$api->get('validate_token', 'AuthController@validateToken');
			
			$api->get('dogs', 'DogsController@index');
			$api->post('dogs', 'DogsController@store');
			$api->get('dogs/{id}', 'DogsController@show');
			$api->delete('dogs/{id}', 'DogsController@destroy');
			$api->put('dogs/{id}', 'DogsController@update');
			
			$api->get('clinics', 'ClinicController@index');
			$api->post('clinics', 'ClinicController@store');
			$api->get('clinics/{id}', 'ClinicController@show');
			$api->delete('clinics/{id}', 'ClinicController@destroy');
			$api->put('clinics/{id}', 'ClinicController@update');

		// });

	});

});