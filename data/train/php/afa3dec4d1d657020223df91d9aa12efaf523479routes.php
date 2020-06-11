<?php

$api_url = Config::get('core::asmoyo.api_prefix_url');

Route::group(['namespace' => 'Asmoyo\Core\Controllers\Api', 'prefix' => $api_url], function() {
	
	Route::resource('page', 'PageApi', array(
		'names' => array(
			'index'		=> 'api.page.index',
			'show'		=> 'api.page.show',
			'store' 	=> 'api.page.store',
			'update' 	=> 'api.page.update',
			'destroy' 	=> 'api.page.destroy',
		),
		'except'	=> ['create', 'edit']
	));

	Route::resource('category', 'CategoryApi', array(
		'names' => array(
			'index'		=> 'api.category.index',
			'show'		=> 'api.category.show',
			'store' 	=> 'api.category.store',
			'update' 	=> 'api.category.update',
			'destroy' 	=> 'api.category.destroy',
		),
		'except'	=> ['create', 'edit']
	));

	Route::resource('tag', 'TagApi', array(
		'names' => array(
			'index'		=> 'api.tag.index',
			'show'		=> 'api.tag.show',
			'store' 	=> 'api.tag.store',
			'update' 	=> 'api.tag.update',
			'destroy' 	=> 'api.tag.destroy',
		),
		'except'	=> ['create', 'edit']
	));

	Route::resource('post', 'PostApi', array(
		'names' => array(
			'index'		=> 'api.post.index',
			'show'		=> 'api.post.show',
			'store' 	=> 'api.post.store',
			'update' 	=> 'api.post.update',
			'destroy' 	=> 'api.post.destroy',
		),
		'except'	=> ['create', 'edit']
	));

});

Route::get('/logout', function() {
	return Auth::logout();
});