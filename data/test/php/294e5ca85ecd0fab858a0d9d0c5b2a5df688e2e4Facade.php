<?php namespace Aptitude;

/**
* Facade
*/
abstract class Facade
{
	/**
	 * The application instance.
	 *
	 * @var \Aptitude\Application
	 */
	protected static $app;

	/**
	 * The service this facade should return from the applications
	 * service container.
	 *
	 * @return void
	 */
	protected static function getFacadeService()
	{
		throw new \RuntimeException('The facade must implement getFacadeService.');
	}

	/**
	 * Set the application instance to use.
	 *
	 * @param  \Aptitude\Application $app
	 * @return void
	 */
	public static function setFacadeApplication(Application $app)
	{
		static::$app = $app;
	}

	/**
	 * When a static call is made to a facade.
	 *
	 * @param  string $method
	 * @param  array  $args
	 * @return mixed
	 */
	public static function __callStatic($method, $args)
	{
		$instance = static::$app[static::getFacadeService()];

		return call_user_func_array(array($instance, $method), $args);
	}
}