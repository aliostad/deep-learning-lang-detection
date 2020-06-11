<?php defined('SYSPATH') OR die('No direct access allowed.');
/**
 * @package  Core
 *
 * Sets the default route to "todos"
 */
$config['_default'] = 'todos';

/*
 * API routing
 */

$config['api/todos']                    = 'todos_api/index';
$config['api/todos/get/([0-9]+)']       = 'todos_api/get/$1';
$config['api/todos/add']                = 'todos_api/add';
$config['api/todos/update/([0-9]+)']    = 'todos_api/update/$1';
$config['api/todos/delete/([0-9]+)']    = 'todos_api/delete/$1';
$config['api/todos/complete/([0-9]+)']  = 'todos_api/complete/$1';