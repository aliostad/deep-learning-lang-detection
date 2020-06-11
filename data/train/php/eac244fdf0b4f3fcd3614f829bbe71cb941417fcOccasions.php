<?php

// Occasions Routes
Route::get( 'api_occasions',['uses' => 'Api\OccasionsController@index']);

Route::get( 'api_occasions/{id}/show',['uses' => 'Api\OccasionsController@show']);

Route::post('api_occasions/create',['uses' => 'Api\OccasionsController@create']);

Route::post('api_occasions/store',['uses' => 'Api\OccasionsController@store']);

Route::get( 'api_occasions/{id}/edit',['uses' => 'Api\OccasionsController@edit']);

Route::post('api_occasions/{id}/update',['uses' => 'Api\OccasionsController@update']);

Route::get( 'api_occasions/{id}/destroy',['uses' => 'Api\OccasionsController@destroy']);
