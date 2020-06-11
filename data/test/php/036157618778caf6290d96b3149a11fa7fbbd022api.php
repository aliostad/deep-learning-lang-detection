<?php

/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
|
| Here is where you can register API routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| is assigned the "api" middleware group. Enjoy building your API!
|
*/

$api = app('Dingo\Api\Routing\Router');

$api->version('v1',  ['prefix' => 'api'], function ($api) {



    $api->group( ['middleware' => 'api.throttle', 'limit' => 105, 'expires' => 1],  function ($api) {
        $api->post('login', 'App\Http\Controllers\API\AuthController@authenticate');
        $api->post('register', 'App\Http\Controllers\API\AuthController@register');

    });

    // All routes in here are protected and thus need a valid token
    $api->group( ['middleware' => ['jwt.auth']], function ($api) {

        $api->get('user', 'App\Http\Controllers\API\AuthController@getAuthenticatedUser');

        $api->get('contacts', 'App\Http\Controllers\API\ContactsController@index');
        $api->put('contactsNew', 'App\Http\Controllers\API\ContactsController@store');
        $api->get('contacts/{id}', 'App\Http\Controllers\API\ContactsController@show');
        $api->delete('contacts/{id}', 'App\Http\Controllers\API\ContactsController@destroy');
        $api->put('contacts/{id}', 'App\Http\Controllers\API\ContactsController@update');

        $api->get('contact/{contactId}/info', 'App\Http\Controllers\API\ContactsInfoController@index');
        $api->post('contact/info', 'App\Http\Controllers\API\ContactsInfoController@store');
        $api->get('contact/{contactId}/info/{id}', 'App\Http\Controllers\API\ContactsInfoController@show');
        $api->delete('contact/info/{id}', 'App\Http\Controllers\API\ContactsInfoController@destroy');
        $api->put('contact/info/{id}', 'App\Http\Controllers\API\ContactsInfoController@update');

    });

});

