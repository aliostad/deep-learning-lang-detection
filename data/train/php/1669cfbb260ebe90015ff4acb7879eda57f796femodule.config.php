<?php

return array(
    'controllers' => array(
        'invokables' => array(
            'Api\Controller\Index'           =>      'Api\Controller\IndexController',
            'Api\Controller\Category'        =>      'Api\Controller\CategoryController',    
            'Api\Controller\Item'            =>      'Api\Controller\ItemController',
            'Api\Controller\Image'           =>      'Api\Controller\ImageController',
            'Api\Controller\FileManager'     =>      'Api\Controller\FileManagerController',    
            'Api\Controller\ServerStatus'    =>      'Api\Controller\ServerStatusController',    
            'Api\Controller\Cli'             =>      'Api\Controller\CliController',
            'Api\Controller\Account'         =>      'Api\Controller\AccountController',    
        )
    ),
    
    'router' => array(
        'routes' => array(
            'api'       => array(
                'type'    => 'segment',
                'options' => array(
                    'route'    => '/api[/:controller[/:action[/:id[/:name]]]]',
                    'defaults' => array(
                        '__NAMESPACE__' => 'Api\Controller',
                        'controller'    => 'Index',
                        'action'        => 'Index',
                        'id' => '[0-9]*',
                        'name' => '.*',
                    ),
                )
            )
        )
    )
    
);