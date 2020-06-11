<?php

namespace App\Providers;

use App\Http\Controllers\Lib\Locator\LocatorCache;
use Illuminate\Support\ServiceProvider;

class LocatorComposerProvider extends ServiceProvider
{
    /**
     * Bootstrap the application services.
     *
     * @return void
     */
    public function boot()
    {
        view()->composer(
            [
                'locator.show',
                'locator.edit',
                'locator.out',
                'locator.showOut',
                'locator.multi',
                'locator.deplacement.multi',
                'locator.out.multi',
                'locator.catalogue.catalogue',
                'locator.last.in',
            ],
            'App\Http\ViewComposer\LocatorComposer'
        );
    }

    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {
        //
    }
}
