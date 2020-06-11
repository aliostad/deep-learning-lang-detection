<?php

	requires ('helpers', 'template');


	function handler_file($handler)
	{
		return handler_dir($handler)."$handler.handler.php";
	}

	function handler_dir($handler)
	{
		$app_dir = php_self_dir();
		return empty($handler) ? $app_dir : $app_dir.'handlers'.DIRECTORY_SEPARATOR.$handler.DIRECTORY_SEPARATOR;
	}

	function handler_templates_dir($handler)
	{
		return handler_dir($handler).'templates'.DIRECTORY_SEPARATOR;
	}

	function handler_func_exists($handler, $func)
	{
		$handler_func = "{$handler}_{$func}";
		if (function_exists($handler_func)) return $handler_func;

		if (!empty($handler))
		{
			$handler_file = handler_file($handler);
			if (file_exists($handler_file)) require_once $handler_file;
			if (function_exists($handler_func)) return $handler_func;
		}

		return false;
	}


	function handler_template($handler, $template)
	{
		return handler_templates_dir($handler)."{$template}.html";
	}

	function handler_layout($handler)
	{
		$handler_layout = handler_templates_dir($handler)."{$handler}_layout.html";
		if (!empty($handler_layout) and template_file_exists($handler_layout)) return $handler_layout;
		else return handler_templates_dir('')."layout.html";
	}

	function call_handler_func($handler, $func)
	{
		$params = array_slice(func_get_args(), 2);
		if ($handler_func = handler_func_exists($handler, $func, php_self_dir()))
			return call_user_func_array($handler_func, $params);
	}


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