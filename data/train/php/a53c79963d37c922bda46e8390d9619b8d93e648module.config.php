<?php

use Action\Service\ActionService;
use Action\Service\ActionServiceFactory;
use Action\Service\IdleService;
use Action\Service\MoveService;
use Action\Service\MoveServiceFactory;

return [
	'input_filters'   => [
		'invokables' => [
		],
	],
	'service_manager' => [
		'invokables' => [
			IdleService::class => IdleService::class,
		],
		'factories'  => [
			ActionService::class => ActionServiceFactory::class,
			MoveService::class   => MoveServiceFactory::class
		],
	],
	'view_manager'    => [
		'template_path_stack' => [
			__DIR__ . '/../view',
		],
		'strategies'          => [
			'ViewJsonStrategy',
		],
	],
];