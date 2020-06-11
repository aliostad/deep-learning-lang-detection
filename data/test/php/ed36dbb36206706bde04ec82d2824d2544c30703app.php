<?php

return array(
		'tiga'		=> array(
			'assets' 		=> 'assets',
			'controller'		=> TIGA_BASE_PATH.'app/Controllers/',
			'model'			=> TIGA_BASE_PATH.'app/Models/',
			'skip_csrf_protect'	=> false  
		),
		'path' 		=> array(
			'storage'	=> TIGA_BASE_PATH.'app/storage/',
			'view'		=> array(TIGA_BASE_PATH.'app/Views/'),
		),
		'provider' => array(
			'Tiga\Framework\ServiceProvider\CoreServiceProvider',
			'Tiga\Framework\ServiceProvider\SessionServiceProvider',
			'Tiga\Framework\ServiceProvider\FormServiceProvider',			
			'Tiga\Framework\ServiceProvider\WhoopsServiceProvider',			
			// 'Tiga\Framework\ServiceProvider\AjaxServiceProvider'			
		),
		'alias' 	=> array(
			'Router'	=> 'Tiga\Framework\Facade\RouterFacade',
			'Routes'	=> 'Tiga\Framework\Facade\RoutesFacade',
			'Request' 	=> 'Tiga\Framework\Facade\RequestFacade',
			'App' 		=> 'Tiga\Framework\Facade\ApplicationFacade',
			'View' 		=> 'Tiga\Framework\Facade\ViewFacade',
			'Template' 	=> 'Tiga\Framework\Facade\TemplateFacade',
			'Response' 	=> 'Tiga\Framework\Facade\ResponseFactoryFacade',
			'DB' 		=> 'Tiga\Framework\Facade\DatabaseFacade',
			'Session' 	=> 'Tiga\Framework\Facade\SessionFacade',
			'Flash' 	=> 'Tiga\Framework\Facade\FlashFacade',
			'Validator' => 'Tiga\Framework\Facade\ValidatorFacade',
			'Paginate' 	=> 'Tiga\Framework\Facade\PaginationFacade',
			'Form' 		=> 'Tiga\Framework\Facade\FormFacade',
			'Html' 		=> 'Tiga\Framework\Facade\HtmlFacade',
			'Config' 	=> 'Tiga\Framework\Facade\ConfigFacade'
		)
	); 
