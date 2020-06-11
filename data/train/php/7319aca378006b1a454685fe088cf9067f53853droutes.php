<?php

App::before(function ($request) {
    $api_path  = '/api/v1/';
    $api_class = 'DLNLab\Features\Classes';
    
	Route::post($api_path . 'get_pincode',   $api_class . '\RestPincode@postGetPincode');
	Route::post($api_path . 'valid_pincode', $api_class . '\RestPincode@postValidPincode');
	
	Route::post($api_path . 'report', $api_class . '\RestReport@postSendReport');
	
	Route::post($api_path . 'notification', $api_class . '\RestNotification@postRead');
	
	Route::post($api_path .   'sessions', $api_class . '\RestSession@postSession');
	Route::delete($api_path . 'sessions', $api_class . '\RestSession@deleteSession');
	
	Route::post($api_path . 'message', $api_class .  '\RestMessage@postAddMessage');
	Route::get($api_path .  'message', $api_class . '\RestMessage@getTest');
	
	Route::post($api_path . 'crawl/parent', $api_class . '\RestCrawl@postAddParentLinks');
	Route::post($api_path . 'crawl/link',   $api_class . '\RestCrawl@postLinks');
    
    Route::post($api_path . 'bitly', $api_class . '\RestBitly@postBitlyLink');
});
