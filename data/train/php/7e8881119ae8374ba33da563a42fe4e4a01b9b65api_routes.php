<?php

$api = app('Dingo\Api\Routing\Router');

$api->version('v1', function ($api) {

    // Auth
    $api->post('auth/login', 'App\Api\V1\Controllers\AuthController@login');
    $api->post('auth/recovery', 'App\Api\V1\Controllers\AuthController@recovery');
    $api->post('auth/reset', 'App\Api\V1\Controllers\AuthController@reset');
    $api->get('auth/refresh', 'App\Api\V1\Controllers\AuthController@token');

    // Profile
    $api->get('users/me', 'App\Api\V1\Controllers\UserController@me');

    // Validation
    $api->post('validate', 'App\Api\V1\Controllers\ValidationController@validateUnique');

    $api->group(['middleware' => ['api.auth']], function ($api) {

        // Screen association
        $api->post('screengroups/{screengroup}/screen/{screen}', 'App\Api\V1\Controllers\ScreenGroupScreenController@store');
        $api->delete('screengroups/{screengroup}/screen/{screen}', 'App\Api\V1\Controllers\ScreenGroupScreenController@destroy');
        $api->delete('categories/{category}/screen/{screen}', 'App\Api\V1\Controllers\CategoryScreenController@destroy');

        // Ticker association
        $api->post('screengroups/{screengroup}/ticker/{ticker}', 'App\Api\V1\Controllers\ScreenGroupTickerController@store');
        $api->delete('screengroups/{screengroup}/ticker/{ticker}', 'App\Api\V1\Controllers\ScreenGroupTickerController@destroy');

        // Client association
        $api->delete('screengroups/{screengroup}/client/{client}', 'App\Api\V1\Controllers\ScreenGroupClientController@destroy');

        // Settings
        $api->get('settings', 'App\Api\V1\Controllers\SettingsController@index');
        $api->put('settings', 'App\Api\V1\Controllers\SettingsController@update');
        $api->put('profile', 'App\Api\V1\Controllers\UserController@updateMe');

        // Models
        $api->resource('categories', 'App\Api\V1\Controllers\CategoryController');
        $api->resource('clients', 'App\Api\V1\Controllers\ClientController');
        $api->resource('screengroups', 'App\Api\V1\Controllers\ScreenGroupController');
        $api->resource('screens', 'App\Api\V1\Controllers\ScreenController');
        $api->post('screens/{id}', 'App\Api\V1\Controllers\ScreenController@replacePhoto');
        $api->resource('tickers', 'App\Api\V1\Controllers\TickerController');
        $api->resource('users', 'App\Api\V1\Controllers\UserController');

        // Activity
        $api->get('activity', 'App\Api\V1\Controllers\ActivityController@index');
        $api->get('activity/{user_id}', 'App\Api\V1\Controllers\ActivityController@index');
        $api->delete('activity/{id}', 'App\Api\V1\Controllers\ActivityController@destroy');

        // Roles
        $api->get('roles', 'App\Api\V1\Controllers\RoleController@index');

    });
});
