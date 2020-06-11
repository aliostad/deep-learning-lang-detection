<?php

return array(
	# Main Application Routes
	'/' 						=> 'Application\Handler\DashboardHandler',

	# Account
	'/login'					=> 'Account\Handler\LoginHtmlHandler',
	'/logout'					=> 'Account\Handler\LoginHtmlHandler',
	'/account'					=> 'Account\Handler\AccountHtmlHandler',
	'/account/password'			=> 'Account\Handler\PasswordHtmlHandler',

	# Account API Endpoints
	"/api/account"				=> "Account\Handler\AccountHandler",
	"/api/account/:alpha"		=> "Account\Handler\AccountHandler",
	"/api/account/login" 		=> "Account\Handler\LoginHandler",
	"/api/account/logout"		=> "Account\Handler\LoginHandler",

	# Key
	"/key" 						=> 'Key\Handler\KeyHtmlHandler',
	# Key API Endpoints
	"/api/key"					=> "Key\Handler\KeyHandler",
	"/api/key/(disable|enable)"	=> "Key\Handler\KeyHandler",
	"/api/key/:alpha"			=> "Key\Handler\KeyHandler",

	# Hook
	"/hook" 					=> "Hook\Handler\HookHtmlHandler",
	# Hook API Endpoints
	"/api/hook"					=> "Key\Handler\KeyHandler",
	"/api/hook/:alpha"			=> "Key\Handler\KeyHandler",
);
