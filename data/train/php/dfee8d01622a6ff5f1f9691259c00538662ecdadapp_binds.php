<?php

/*
|--------------------------------------------------------------------------
| Repository binds
|--------------------------------------------------------------------------
|
| 
| 
| 
|
*/

App::bind('Repositories\\User\\UserRepositoryInterface', 'Repositories\\User\\UserRepository');
App::bind('Repositories\\Admin\\AdminRepositoryInterface', 'Repositories\\Admin\\AdminRepository');
App::bind('Repositories\\Client\\ClientRepositoryInterface', 'Repositories\\Client\\ClientRepository');
App::bind('Repositories\\Product\\ProductRepositoryInterface', 'Repositories\\Product\\ProductRepository');
App::bind('Repositories\\Platform\\PlatformRepositoryInterface', 'Repositories\\Platform\\PlatformRepository');
App::bind('Repositories\\Category\\CategoryRepositoryInterface', 'Repositories\\Category\\CategoryRepository');
App::bind('Repositories\\Developer\\DeveloperRepositoryInterface', 'Repositories\\Developer\\DeveloperRepository');
App::bind('Repositories\\Publisher\\PublisherRepositoryInterface', 'Repositories\\Publisher\\PublisherRepository');
App::bind('Repositories\\Game\\GameRepositoryInterface', 'Repositories\\Game\\GameRepository');
App::bind('Repositories\\Language\\LanguageRepositoryInterface', 'Repositories\\Language\\LanguageRepository');
App::bind('Repositories\\Agerate\\AgerateRepositoryInterface', 'Repositories\\Agerate\\AgerateRepository');