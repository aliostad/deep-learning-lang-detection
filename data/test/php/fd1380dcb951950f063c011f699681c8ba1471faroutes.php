<?php

Route::get('/test', 'Repository\UserRepository\UserRepository@insert');

Route::post('/update', 'Repository\UserRepository\UserRepository@updateC');

Route::post('/find', 'Repository\UserRepository\UserRepository@findC');

Route::post('/getAll', 'Repository\UserRepository\UserRepository@getAll');

Route::post('/insert', 'Repository\UserRepository\UserRepository@insertC');

Route::post('/delete', 'Repository\UserRepository\UserRepository@deleteC');

Route::get('/{request}', 'Service\BaseCallerService@connect');

Route::get('home', 'HomeController@index');

Route::controllers([
	'auth' => 'Auth\AuthController',
	'password' => 'Auth\PasswordController',
]);
