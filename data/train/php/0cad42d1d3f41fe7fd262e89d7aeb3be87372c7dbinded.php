<?php

/*
|--------------------------------------------------------------------------
| Repository binded.
|--------------------------------------------------------------------------
|
| Application repositories.
|
*/

App::bind('PAppRepositoryInterface', 'PAppRepository');
App::bind('ProductRepositoryInterface', 'ProductRepository');
App::bind('CartRepositoryInterface', 'CartRepository');
App::bind('StockRepositoryInterface', 'StockRepository');
App::bind('PaymentRepositoryInterface', 'PaymentRepository');
App::bind('OrderRepositoryInterface', 'OrderRepository');
App::bind('CheckoutRepositoryInterface', 'CheckoutRepository');
App::bind('ShippingMethodRepositoryInterface', 'ShippingMethodRepository');
App::bind('SupplyChainRepositoryInterface', 'SupplyChainRepository');
App::bind('MessageRepositoryInterface', 'MessageRepository');
App::bind('ElasticRepositoryInterface', 'ElasticRepository');
App::bind('HolidayRepositoryInterface', 'HolidayRepository');

/*
App::singlton('elastica', function()
{
	$elastica = new \Elastica\Client(array(
        'host' => 'pcms.igetapp.com',
        'port' => 9200
    ));

	return (object) $elastica;
});
*/