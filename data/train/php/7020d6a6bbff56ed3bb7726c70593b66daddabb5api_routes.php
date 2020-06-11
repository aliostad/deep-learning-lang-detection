<?php
/*
|--------------------------------------------------------------------------
| API Routes
|--------------------------------------------------------------------------
*/

/**
 * @var \Dingo\Api\Routing\Router $api
 */
$api = app('Dingo\Api\Routing\Router');

$api->version('v1', ['namespace' => 'App\Api\v1\controllers'], function ($api) {

    $api->group(['prefix' => 'v1'], function($api){
        $api->group(['prefix' => 'contacts'], function ($api) {
            $api->post('/create', ['uses' => 'ContactsController@store']);
            $api->get('/', ['uses' => 'ContactsController@index']);
            $api->get('/{id}', ['uses' => 'ContactsController@show']);
            $api->patch('/update/{id}', ['uses' => 'ContactsController@update']);
            $api->delete('/delete/{id}', ['uses' => 'ContactsController@destroy']);
            $api->delete('/archive/{id}', ['uses' => 'ContactsController@archive']);
            $api->put('/restore/{id}', ['uses' => 'ContactsController@restore']);

        });
    });

});