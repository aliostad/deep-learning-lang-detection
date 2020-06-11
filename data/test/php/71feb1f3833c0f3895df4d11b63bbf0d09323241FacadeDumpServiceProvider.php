<?php

namespace Gsaulmon\LaravelFacadeDump;

use Illuminate\Support\ServiceProvider;

class FacadeDumpServiceProvider extends ServiceProvider {

	protected $defer = true;

	public function boot()
	{
		$this->package('gsaulmon/laravel-facade-dump');
	}

	public function register()
	{

        $this->app['command.facade-dump'] = $this->app->share(function($app)
        {
            return new GeneratorCommand;
        });
        $this->commands('command.facade-dump');
	}

	public function provides()
	{
        return array('command.facade-dump');
	}

}
