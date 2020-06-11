<?php

CroogoNav::add('webshop-customer-dashboard', 'users', array(
	'title' => __d('webshop_customer_users', 'Users'),
	'url' => array(
		'prefix' => 'panel',
		'plugin' => 'webshop_customer_users',
		'controller' => 'customer_users',
		'action' => 'index'
	),
));

Croogo::hookBehavior('Customer', 'WebshopCustomerUsers.CustomerWithUsers');

Croogo::hookComponent('*', 'WebshopCustomerUsers.CustomerUsers');

Croogo::mergeConfig('Webshop.customer_access_providers', array(
	'CustomerUsers' => array(
		'provider' => 'WebshopCustomerUsers.CustomerUser'
	),
));
