<?php

$app->get('/', 'Api\Controller\ApiController::indexAction');
$app->get('/api', 'Api\Controller\ApiController::indexAction');
$app->get('/api/errors', 'Api\Controller\ErrorsController::indexAction');
$app->get('/api/errors/{code}', 'Api\Controller\ErrorsController::detailAction');
$app->get('/api/customers', 'Api\Controller\CustomersController::indexAction');
$app->get('/api/customers/{cid}', 'Api\Controller\CustomersController::detailAction');
$app->get('/api/customers/{cid}/licenses', 'Api\Controller\CustomersController::licensesAction');
$app->get('/api/customers/{cid}/licenses/{lid}', 'Api\Controller\CustomersController::licensesDetailAction');

$app->match("{url}", function($url) use ($app) { return "OK"; })->assert('url', '.*')->method("OPTIONS");

