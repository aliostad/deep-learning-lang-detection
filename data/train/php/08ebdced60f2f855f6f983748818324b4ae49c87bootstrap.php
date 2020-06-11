<?php

use JGimeno\TaskReporter\App\ServiceProvider;
use League\Container\Container;

require_once 'vendor/autoload.php';

$container = new Container();

$container->share('isDevMode', true);

$container
    ->addServiceProvider(new ServiceProvider\MailServiceProvider())
    ->addServiceProvider(new ServiceProvider\ConfigurationServiceProvider())
    ->addServiceProvider(new ServiceProvider\RepositoryServiceProvider())
    ->addServiceProvider(new ServiceProvider\CommandServiceProvider())
    ->addServiceProvider(new ServiceProvider\ConsoleServiceProvider());
