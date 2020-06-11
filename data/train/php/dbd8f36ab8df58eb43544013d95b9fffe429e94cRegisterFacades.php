<?php namespace Consolle\Foundation\Bootstrap;

use Illuminate\Support\Facades\Facade;
use Consolle\Foundation\AliasLoader;
use Illuminate\Contracts\Foundation\Application;

class RegisterFacades {

	/**
	 * Bootstrap the given application.
	 *
	 * @param  \Illuminate\Contracts\Foundation\Application  $app
	 * @return void
	 */
	public function bootstrap(Application $app)
	{
		Facade::clearResolvedInstances();

		Facade::setFacadeApplication($app);

		AliasLoader::getInstance($app['config']['app.aliases'])->register();
	}

}
