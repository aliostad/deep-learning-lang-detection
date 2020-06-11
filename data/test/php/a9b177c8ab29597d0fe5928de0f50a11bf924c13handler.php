<?php

	requires ('helpers', 'template');


	function handler_func_resolver($handler_func)
	{
		if (!str_contains('/', $handler_func)) return array('', $handler_func);
		$pieces = explode('/', $handler_func);
		$func = array_pop($pieces);
		$handler = implode('/', $pieces);
		return array($handler, $func);
	}


	function handler_dir($handler)
	{
		$handler_basedir = php_self_dir().'handlers'.DIRECTORY_SEPARATOR;
		return $handler_basedir.str_slashes_to_directory_separator($handler).DIRECTORY_SEPARATOR;
	}

	function handler_templates_dir($handler)
	{
		$basedir = empty($handler) ? php_self_dir() : handler_dir($handler);
		return $basedir.'templates'.DIRECTORY_SEPARATOR;
	}


	function handler_file($handler)
	{
		if (str_contains('/', $handler))
		{
			$pieces = explode('/', $handler);
			$handler_basename = array_pop($pieces);
		}
		else $handler_basename = $handler;
		return handler_dir($handler)."$handler_basename.handler.php";
	}


	function handler_template($handler_template)
	{
		list($handler, $template) = handler_func_resolver($handler_template);
		return handler_templates_dir($handler)."{$template}.html";
	}

	function handler_layout($handler)
	{
		$handler_layout = handler_templates_dir($handler)."{$handler}_layout.html";
		if (!empty($handler_layout) and template_file_exists($handler_layout)) return $handler_layout;
		else return handler_templates_dir('')."layout.html";
	}


	function handler_require_once($handler)
	{
		$handler_file = handler_file($handler);
		if (file_exists($handler_file)) require_once $handler_file;
		else return false;
	}


	function handler_func_exists($handler_func)
	{
		list($handler, $func) = handler_func_resolver($handler_func);
		if (function_exists($func)) return $func;

		if (!empty($handler))
		{
			handler_require_once($handler);
			if (function_exists($func)) return $func;
		}

		return false;
	}


	function call_handler_func($handler_func)
	{
		$params = array_slice(func_get_args(), 1);
		if ($func = handler_func_exists($handler_func))	return call_user_func_array($func, $params);
		else trigger_error("Handler func ($handler_func) not found.", E_USER_ERROR);
	}




//TODO: Revisit this email stuff later
	function handler_sendmail($handler, $email, $resource)
	{
		require_once handler_email_file($handler, php_self_dir());
		$args = func_get_args();
		$handler_email_func_args = array_slice($args, 2);
		$handler_email_func = "{$handler}_{$email}_email";
		$params = call_user_func_array($handler_email_func, $handler_email_func_args);
		 // TODO: is this all I need to send to the email template?
		$template_vars = array('resource'=>$resource, 'params'=>$params);
		if (isset($params['message'])) $message = $params['message'];
		else $message = template_compose(handler_email_template($handler, $email), $template_vars,
		                                 handler_email_layout($handler), $template_vars);

		return emailmodule_sendmail($params['from'], $params['to'], $params['subject'], $message);
	}

		function handler_email_file($handler, $app_dir)
		{
			return $app_dir.'handlers'.DIRECTORY_SEPARATOR.$handler.DIRECTORY_SEPARATOR."$handler.email.php";
		}

//TODO: The fact that for the app level ones you have to pass an empty string for the handler param in handler_sendmail sucks
		function handler_email_template($handler, $email)
		{
			return handler_templates_dir($handler)."email/$email.txt";
		}

		function handler_email_layout($handler)
		{
			$handler_email_layout = handler_templates_dir($handler)."email/layout.txt";
			if (!empty($handler_email_layout) and template_file_exists($handler_email_layout)) return $handler_email_layout;
			else return handler_templates_dir('')."email/layout.html";
		}

?>