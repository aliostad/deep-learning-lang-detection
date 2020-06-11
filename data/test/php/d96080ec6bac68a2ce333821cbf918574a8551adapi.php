<?php
$api = app('Dingo\Api\Routing\Router');
//$params = [
//    'as' => 'api::',
//    'version' => 'v1',
//    'domain' => env('APP_DOMAIN'), // Notice we use the domain WITHOUT port number
//    'namespace' => 'App\\Http\\Controllers',
//];
//$api->version($params, function ($api) {
//
//    $api->get('test', function () {
//        return 'It is ok';
//    });
//
//});

//to See routes
//php artisan api:routes


$routerList =  function ($api) {
  $api->any('/test','TestController@test')->middleware(['CheckAge']);
//  $api->any('/test','TestController@test');
};

$api->version('v1',['domain'=> env('API_DOMAIN'),'namespace'=> 'App\Http\Controllers\Api\V1'],$routerList);
