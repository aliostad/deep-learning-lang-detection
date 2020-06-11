<?php

namespace App\Providers;

use Illuminate\Support\ServiceProvider;
use App\Service\SellerService;
use App\Service\ISocialService;

class SellerServiceProvider extends ServiceProvider
{
    /**
     * Bootstrap the application services.
     *
     * @return void
     */
    public function boot()
    {
        //
    }

    /**
     * Register the application services.
     *
     * @return void
     */
    public function register()
    {
        $this->app->singleton('App\Service\SellerService', function(ISocialService $socialService) {
            $sellerService = new SellerService($socialService);
            return $sellerService;
        });
    }
}
