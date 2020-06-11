<?php
return array(
	//服务
	'provider' => array(
		'Hdphp\Error\ErrorServiceProvider',
		'Hdphp\Config\ConfigServiceProvider',
		'Hdphp\Log\LogServiceProvider',
		'Hdphp\Route\RouteServiceProvider',
		'Hdphp\View\ViewServiceProvider',
		'Hdphp\Url\UrlServiceProvider',
		'Hdphp\Db\DbServiceProvider',
		'Hdphp\Request\RequestServiceProvider',
		'Hdphp\Page\PageServiceProvider',
		'Hdphp\Code\CodeServiceProvider',
		'Hdphp\Cache\CacheServiceProvider',
		'Hdphp\Cart\CartServiceProvider',
		'Hdphp\Crypt\CryptServiceProvider',
		'Hdphp\Image\ImageServiceProvider',
		'Hdphp\Upload\UploadServiceProvider',
		'Hdphp\Dir\DirServiceProvider',
		'Hdphp\String\StringServiceProvider',
		'Hdphp\Data\DataServiceProvider',
		'Hdphp\Lang\LangServiceProvider',
		'Hdphp\Html\HtmlServiceProvider',
		'Hdphp\Arr\ArrServiceProvider',
		'Hdphp\Session\SessionServiceProvider',
		'Hdphp\Cookie\CookieServiceProvider',
		'Hdphp\Xml\XmlServiceProvider',
		'Hdphp\Response\ResponseServiceProvider',
		'Hdphp\Validate\ValidateServiceProvider',
		'Hdphp\Rbac\RbacServiceProvider',
		'Hdphp\Weixin\WeixinServiceProvider',
		'Hdphp\Mail\MailServiceProvider',
		'Hdphp\Backup\BackupServiceProvider',
		'Hdphp\Zip\ZipServiceProvider',
		'Hdphp\Curl\CurlServiceProvider',
	),

	//外观
	'facade'   => array(
		'App'      => 'Hdphp\Facade\AppFacade',
		'Config'   => 'Hdphp\Facade\ConfigFacade',
		'Log'      => 'Hdphp\Facade\LogFacade',
		'Error'    => 'Hdphp\Facade\ErrorFacade',
		'Route'    => 'Hdphp\Facade\RouteFacade',
		'View'     => 'Hdphp\Facade\ViewFacade',
		'Url'      => 'Hdphp\Facade\UrlFacade',
		'Db'       => 'Hdphp\Facade\DbFacade',
		'Request'  => 'Hdphp\Facade\RequestFacade',
		'Page'     => 'Hdphp\Facade\PageFacade',
		'Code'     => 'Hdphp\Facade\CodeFacade',
		'Cache'    => 'Hdphp\Facade\CacheFacade',
		'Cart'     => 'Hdphp\Facade\CartFacade',
		'Crypt'    => 'Hdphp\Facade\CryptFacade',
		'Image'    => 'Hdphp\Facade\ImageFacade',
		'Upload'   => 'Hdphp\Facade\UploadFacade',
		'Dir'      => 'Hdphp\Facade\DirFacade',
		'String'   => 'Hdphp\Facade\StringFacade',
		'Data'     => 'Hdphp\Facade\DataFacade',
		'Lang'     => 'Hdphp\Facade\LangFacade',
		'Html'     => 'Hdphp\Facade\HtmlFacade',
		'Arr'      => 'Hdphp\Facade\ArrFacade',
		'Session'  => 'Hdphp\Facade\SessionFacade',
		'Cookie'   => 'Hdphp\Facade\CookieFacade',
		'Xml'      => 'Hdphp\Facade\XmlFacade',
		'Response' => 'Hdphp\Facade\ResponseFacade',
		'Validate' => 'Hdphp\Facade\ValidateFacade',
		'Rbac'     => 'Hdphp\Facade\RbacFacade',
		'Weixin'   => 'Hdphp\Facade\WeixinFacade',
		'Mail'     => 'Hdphp\Facade\MailFacade',
		'Backup'   => 'Hdphp\Facade\BackupFacade',
		'Zip'      => 'Hdphp\Facade\ZipFacade',
		'Curl'     => 'Hdphp\Facade\CurlFacade',
	)
);