<?php


$api = app('Dingo\Api\Routing\Router');

$api->version('v1', function ($api) {

	$api->post('auth/login', 'App\Api\V1\Controllers\AuthController@login');
	$api->post('auth/signup', 'App\Api\V1\Controllers\AuthController@signup');
	$api->post('auth/recovery', 'App\Api\V1\Controllers\AuthController@recovery');
	$api->post('auth/reset', 'App\Api\V1\Controllers\AuthController@reset');
	$api->get('index','App\Api\V1\Controllers\AuthController@index');

	// example of protected route
	$api->get('protected', ['middleware' => ['api.auth'], function () {		
		return \App\User::all();
    }]);

	// example of free route
	$api->get('free', function() {
		return \App\User::all();
	});

	// $api->group(['middleware' => 'api.auth'], function ($api) {
	// $api->get('book', 'App\Api\V1\Controllers\BookController@index');
	// $api->get('book/{id}', 'App\Api\V1\Controllers\BookController@show');
	// $api->post('book', 'App\Api\V1\Controllers\BookController@store');
	// $api->put('book/{id}', 'App\Api\V1\Controllers\BookController@update');
	// $api->delete('book/{id}', 'App\Api\V1\Controllers\BookController@destroy');
	// });

});
