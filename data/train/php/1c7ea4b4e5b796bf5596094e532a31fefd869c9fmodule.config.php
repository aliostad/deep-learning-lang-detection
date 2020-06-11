<?php
return array(
    'controllers' => array(
        'factories' => array(
            'SampleService\Controller\User' => 'SampleService\Controller\Service\UserControllerFactory',
        ),
    ),
    'service_manager' => array(
        'factories' => array(
            'SampleService\Mapper\UserMapper'         => 'SampleService\Mapper\Service\UserMapperFactory',

            'SampleService\Service\UserService'       => 'SampleService\Service\Service\UserServiceFactory',
            'SampleService\Service\UserFilterStorage' => 'SampleService\Service\Service\UserFilterStorageFactory',
            'SampleService\Service\UserFilterService' => 'SampleService\Service\Service\UserFilterServiceFactory',
            'ProxyManager\Configuration'              => 'SampleService\ProxyManager\Service\ConfigurationFactory',
        )
    ),

    // The following section is new and should be added to your file
    'router' => array(
        'routes' => array(
            'user-filter' => array(
                'type' => 'literal',
                'options' => array(
                    'route' => '/users/filter',
                    'defaults' => array(
                        'controller' => 'SampleService\Controller\User',
                        'action' => 'filter',
                    ),
                ),
                'may_terminate' => true,
                'child_routes' => array(
                    'filter' => array(
                        'type' => 'wildcard',
                        'may_terminate' => true,
                        'options' => array(
                            'key_value_delimiter' => ',',
                        ),
                    ),
                ),
            ),
        ),
    ),

    'view_manager' => array(
        'template_path_stack' => array(
            'album' => __DIR__ . '/../view',
        ),
    ),

    'proxyManager' => array(
        //'proxiesTargetDir' => __DIR__ . '../../data/'
    ),
);