<?php

use Illuminate\Support\Facade;

class App extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return static::$app; }

}

class Auth extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'auth'; }

}

class Cache extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'cache'; }

}

class Cookie extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'cookie'; }

}

class Crypt extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'encrypter'; }

}

class DB extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'db'; }

}

class Event extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'events'; }

}

class Input extends Facade {

	/**
	 * Get an item from the input data.
	 *
	 * This method is used for all request verbs (GET, POST, PUT, and DELETE)
	 *
	 * @param  string $key
	 * @param  mixed  $default
	 * @return mixed
	 */
	public static function get($key = null, $default = null)
	{
		return static::$app['request']->input($key, $default);
	}

	/**
	 * Get all of the input data for the request, including files.
	 * @return array
	 */
	public static function all()
	{
		return static::$app['request']->everything();
	}

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'request'; }

}

class Profiler extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'profiler'; }

}

class Request extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'request'; }

}

class Response extends Facade {

	/**
	 * Return a new response from the application.
	 *
	 * @param  string  $content
	 * @param  int     $status
	 * @param  array   $headers
	 * @return Symfony\Component\HttpFoundation\Response
	 */
	public static function make($content = '', $status = 200, array $headers = array())
	{
		return static::$app->respond($content, $status, $headers);
	}

	/**
	 * Convert some data into a JSON response.
	 *
	 * @param  mixed  $data
	 * @param  int    $status
	 * @param  array  $headers
	 * @return Symfony\Component\HttpFoundation\JsonResponse
	 */
	public static function json($data = array(), $status = 200, array $headers = array())
	{
		return static::$app->json($data, $status, $headers);
	}

}

class Route extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'router'; }

}

class Session extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'session'; }

}

class Validator extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'validator'; }

}

class View extends Facade {

	/**
	 * Get the registered name of the component.
	 *
	 * @return string
	 */
	protected static function getFacadeAccessor() { return 'blade'; }

}