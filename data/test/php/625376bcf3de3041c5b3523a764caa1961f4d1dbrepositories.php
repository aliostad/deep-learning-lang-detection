<?php

use Silex\Application;

$app['repository.users'] = $app->share(function(Application $app){
    return new Ordering\Repository\UserRepository($app);
});

$app['repository.products'] = $app->share(function(Application $app){
    return new Ordering\Repository\ProductRepository($app);
});

$app['repository.orders'] = $app->share(function(Application $app){
    return new Ordering\Repository\OrderRepository($app);
});

$app['repository.orderProducts'] = $app->share(function(Application $app){
    return new Ordering\Repository\OrderProductRepository($app);
});