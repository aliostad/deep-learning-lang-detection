<?php

use Dingo\Api\Routing\Router;

/** @var Router $api */
$api = app(Router::class);

$api->version('v1', function (Router $api) {
    $api->group(['prefix' => 'v1'], function(Router $api) {
        $api->post('balance', 'App\\Http\\Controllers\\AccountsApiController@balance');
        $api->post('deposit', 'App\\Http\\Controllers\\AccountsApiController@deposit');
        $api->post('withdraw', 'App\\Http\\Controllers\\AccountsApiController@withdraw');
        $api->post('create_account', 'App\\Http\\Controllers\\AccountsApiController@store');
    });
});
