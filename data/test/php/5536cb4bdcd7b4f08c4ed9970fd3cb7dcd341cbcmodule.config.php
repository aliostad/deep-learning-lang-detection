<?php
return array(
    'entities' => [
        'customer' => [
            'repositoryServiceName' => 'customerRepository',
            'className' => 'Application\Model\Customer'
        ],
        'planning' => [
            'repositoryServiceName' => 'planningRepository',
            'className' => 'Application\Model\Planning\Planning'
        ],
        'homePage' => [
            'className' => 'Application\Model\HomePage',
        ],
    ],
    'service_manager' => [
        'invokables' => [
            'customerRepository' => 'Application\Repository\CustomerRepository',
            'timeSlotRepository' => 'Application\Repository\TimeSlotRepository',
            'planningRepository' => 'Application\Repository\PlanningRepository',
            'batchRepository' => 'Application\Repository\BatchRepository',
        ],
    ],
    'view_manager' => [
        'display_not_found_reason' => true,
        'display_exceptions'       => true,
        'doctype'                  => 'HTML5',
        'not_found_template'       => 'error/404',
        'exception_template'       => 'error/index',
        'template_map' => [
            'layout/layout'           => __DIR__ . '/../view/layout/layout.phtml',
            'error/404'               => __DIR__ . '/../view/error/404.phtml',
            'error/index'             => __DIR__ . '/../view/error/index.phtml',
        ],
        'template_path_stack' => [
            __DIR__ . '/../view',
        ],
    ],
);
