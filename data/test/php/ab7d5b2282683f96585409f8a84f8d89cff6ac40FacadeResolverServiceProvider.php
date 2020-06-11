<?php namespace Bagwaa\FacadeResolver;

use Illuminate\Support\ServiceProvider;

class FacadeResolverServiceProvider extends ServiceProvider
{
    protected $defer = false;

    public function register()
    {
        $this->registerFacadeResolver();

        $this->commands(
            'facade.resolve'
        );
    }

    public function provides()
    {
        return array();
    }

    protected function registerFacadeResolver()
    {
        $this->app['facade.resolve'] = $this->app->share(
            function () {
                return new Commands\FacadeResolverCommand();
            }
        );
    }
}
